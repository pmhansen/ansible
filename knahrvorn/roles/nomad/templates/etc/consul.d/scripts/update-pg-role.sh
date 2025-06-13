#!/bin/bash

CONSUL_DIR="/etc/consul.d"
CLUSTERS=({{ postgres.clusters | map(attribute='name') | join(' ') }})
PORTS=({{ postgres.clusters | map(attribute='port') | join(' ') }})

export PGHOST=knahrvorn-eno1
export PGDATABASE=postgres
export PGUSER={{ postgres.user }}
export PGPASSWORD={{ postgres.pass }}

NEED_RELOAD=0

for i in "${!CLUSTERS[@]}"; do

  ROLE=$(psql -p ${PORTS[i]} -tAc "SELECT pg_is_in_recovery();" 2>/dev/null)
  MASTER_FILE="$CONSUL_DIR/services/pg-master-${CLUSTERS[i]}.hcl"
  SLAVE_FILE="$CONSUL_DIR/services/pg-slave-${CLUSTERS[i]}.hcl"

  if [[ "$ROLE" == "f" ]]; then

    # Register as master and remove as slave if not already
    if [[ ! -f "$MASTER_FILE" ]]; then
      cp /etc/consul.d/templates/pg-master-${CLUSTERS[i]}.tmpl "$MASTER_FILE"
      NEED_RELOAD=1
    fi
    
    if [[ -f "$SLAVE_FILE" ]]; then
      rm -f "$SLAVE_FILE"
      NEED_RELOAD=1
    fi

  elif [[ "$ROLE" == "t" ]]; then
    # Register as slave and remove as master if not already

    if [[ ! -f "$SLAVE_FILE" ]]; then
      cp /etc/consul.d/templates/pg-slave-${CLUSTERS[i]}.tmpl "$SLAVE_FILE"
      NEED_RELOAD=1
    fi
    
    if [[ -f "$MASTER_FILE" ]]; then
      rm -f "$MASTER_FILE"
      NEED_RELOAD=1
    fi

  else
    echo "Unable to determine role"
    exit 1
  fi
done

if [[ "$NEED_RELOAD" -eq 1 ]]; then
  consul reload
fi

#!/bin/bash

CONSUL_DIR="/etc/consul.d"
CLUSTERS=({{ postgres.clusters | map(attribute='name') | join(' ') }})
PORTS=({{ postgres.clusters | map(attribute='port') | join(' ') }})

export PGHOST=knahrvorn-eno1
export PGDATABASE=postgres
export PGUSER={{ postgres.user }}
export PGPASSWORD={{ postgres.pass }}

for i in "${!CLUSTERS[@]}"; do

  ROLE=$(psql -p ${PORTS[i]} -tAc "SELECT pg_is_in_recovery();" 2>/dev/null)

  if [[ "$ROLE" == "f" ]]; then
    # Register as master
    cp /etc/consul.d/templates/pg-master-${CLUSTERS[i]}.tmpl $CONSUL_DIR/services/pg-master-${CLUSTERS[i]}.hcl
    # Unregister as slave
    rm -f "$CONSUL_DIR/services/pg-slave-${CLUSTERS[i]}.hcl"
  elif [[ "$ROLE" == "t" ]]; then
    # Register as slave
    cp /etc/consul.d/templates/pg-slave-${CLUSTERS[i]}.tmpl $CONSUL_DIR/services/pg-slave-${CLUSTERS[i]}.hcl
    # Unregister as master
    rm -f "$CONSUL_DIR/services/pg-master-${CLUSTERS[i]}.hcl"
  else
    echo "Unable to determine role"
    exit 1
  fi
done

consul reload

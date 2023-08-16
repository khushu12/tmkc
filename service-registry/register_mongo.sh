#!/bin/bash
cloudMongoURIFilePath="/opt/celona/etc/cloud-mongo-uri"
CN_SERVICE_REGISTRY_IP=$(cat /opt/celona/etc/svc_reg_ip)
CN_SERVICE_REGISTRY_PORT=$(cat /opt/celona/etc/svc_reg_port)

sleep_count=0
max_sleep_count=60
while :
do
    if [ ! -f ${cloudMongoURIFilePath} ]; then
        echo "Registering mongo as local installations"
        if /opt/celona/bin/grpcurl -plaintext -d '{"name": "cn-mongo-headless", "endpoint": [{"port":"27017", "protocol": 1}]}' ${CN_SERVICE_REGISTRY_IP}:${CN_SERVICE_REGISTRY_PORT} serviceregistry2.ServiceRegistry2/RegisterService; then
            echo "Registered cn-mongo-headless as local installation successfully"
        else
            echo "Registering cn-mongo-headless as local installation failed"
            sleep 2
            sleep_count=$((sleep_count+1))
            if [[ sleep_count -ge max_sleep_count ]]; then
                break
            fi
            continue
        fi
        if /opt/celona/bin/grpcurl -plaintext -d '{"name": "cn-mongo", "endpoint": [{"port":"27017", "protocol": 1}]}' ${CN_SERVICE_REGISTRY_IP}:${CN_SERVICE_REGISTRY_PORT} serviceregistry2.ServiceRegistry2/RegisterService; then
            echo "Registered cn-mongo as local installation successfully"
            break
        else
            echo "Registering cn-mongo as local installation failed"
            sleep 2
            sleep_count=$((sleep_count+1))
            if [[ sleep_count -ge max_sleep_count ]]; then
                break
            fi
            continue
        fi
    else
        echo "Register cn-mongo-headless as atlas installation"
        uri=$(< ${cloudMongoURIFilePath} tr -d '\n')
        if /opt/celona/bin/grpcurl -plaintext -d '{"name": "cn-mongo-headless", "endpoint": [{"url":"'${uri}'"}]}' ${CN_SERVICE_REGISTRY_IP}:${CN_SERVICE_REGISTRY_PORT} serviceregistry2.ServiceRegistry2/RegisterService; then
            echo "Registered cn-mongo-headless as atlas installation successfully"
            break
        else
            echo "Registering cn-mongo-headless as atlas installation failed"
            sleep 2
            sleep_count=$((sleep_count+1))
            if [[ sleep_count -ge max_sleep_count ]]; then
                break
            fi
            continue
        fi
    fi
done

FROM scratch

COPY ./etcd-download/etcd /bin/
COPY ./etcd-download/etcdctl /bin/

EXPOSE 2379
EXPOSE 2380
CMD [ "etcd" ]

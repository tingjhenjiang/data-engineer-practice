# -- Software Stack Version

SPARK_VERSION="3.1.2"
HADOOP_VERSION="3.2"
JUPYTERLAB_VERSION="3.1.11"

# -- Building the Images

docker build -f cluster-base.Dockerfile -t cluster-base .

docker build \
  --build-arg spark_version="${SPARK_VERSION}" \
  --build-arg hadoop_version="${HADOOP_VERSION}" \
  -f spark-base.Dockerfile \
  -t spark-base .

docker build -f spark-master.Dockerfile -t spark-master .
docker build -f spark-worker.Dockerfile -t spark-worker .
docker build -f jupyterhub-base.Dockerfile -t jupyterhub-base .
docker build -f jupyterhub-run_pyr.Dockerfile -t jupyterhub-run_pyr .
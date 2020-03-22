---
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: nginx-to-scaleout
spec:
  replicas: 10
  template:
    metadata:
      labels:
        service: nginx
        app: nginx
    spec:
      containers:
      - image: nginx
        name: nginx-to-scaleout
        resources:
          limits:
            cpu: 500m
            memory: 512Mi
          requests:
            cpu: 500m
            memory: 512Mi

# kubectl apply -f ./k8s-fixtures/autoscaling.yaml
# kubectl delete -f ./k8s-fixtures/autoscaling.yaml
# or
# kubectl create deployment autoscaler-demo --image=nginx
# kubectl scale deployment autoscaler-demo --replicas=50

# Kubernetes 部署指南

这里提供一份Kubernetes部署的例子，需要在Kubernetes集群中运行MCP飞书项目服务的可以参考。

## 前提条件

- 一个可用的Kubernetes集群
- 已安装kubectl命令行工具
- 具有创建Deployment、ConfigMap和Secret的权限

## 部署步骤

### 1. 准备Secret

首先，需要创建包含敏感信息的Secret。由于Kubernetes Secret需要使用base64编码的值，您需要对敏感信息进行编码：

```bash
# 对敏感信息进行base64编码
echo -n "your_project_key" | base64
echo -n "your_user_key" | base64
echo -n "your_plugin_id" | base64
echo -n "your_plugin_secret" | base64
```

然后，使用生成的base64编码值更新`k8s-secret.yaml`文件中的相应字段。

### 2. 应用配置

依次应用以下配置文件：

```bash
# 创建ConfigMap
kubectl apply -f k8s-configmap.yaml

# 创建Secret
kubectl apply -f k8s-secret.yaml

# 创建Deployment
kubectl apply -f k8s-deployment.yaml
```

### 3. 验证部署

检查部署状态：

```bash
# 查看Deployment状态
kubectl get deployments

# 查看Pod状态
kubectl get pods

# 查看Pod日志
kubectl logs -f <pod-name>
```

## 自定义配置

### 资源限制

如果需要调整资源限制，可以修改`k8s-deployment.yaml`文件中的resources部分：

```yaml
resources:
  limits:
    cpu: "500m"    # 0.5 CPU核心
    memory: "512Mi"  # 512MB内存
  requests:
    cpu: "100m"    # 0.1 CPU核心
    memory: "128Mi"  # 128MB内存
```

### 副本数量

如果需要运行多个实例，可以修改`k8s-deployment.yaml`文件中的replicas字段：

```yaml
replicas: 3  # 运行3个副本
```

### 暴露服务

如果需要暴露服务，取消`k8s-deployment.yaml`文件中Service部分的注释，并根据需要修改服务类型：

```yaml
apiVersion: v1
kind: Service
metadata:
  name: mcp-feishu-proj
spec:
  selector:
    app: mcp-feishu-proj
  ports:
  - port: 8000
    targetPort: 8000
  type: ClusterIP  # 可选值：ClusterIP, NodePort, LoadBalancer
```

## 更新应用

当需要更新应用时，可以使用以下命令：

```bash
# 更新Deployment
kubectl apply -f k8s-deployment.yaml

# 或者直接设置新的镜像版本
kubectl set image deployment/mcp-feishu-proj mcp-feishu-proj=ghcr.io/astral-sh/uv:新版本
```

## 删除应用

如果需要删除应用，可以使用以下命令：

```bash
kubectl delete -f k8s-deployment.yaml
kubectl delete -f k8s-secret.yaml
kubectl delete -f k8s-configmap.yaml
```

## 故障排除

如果遇到问题，可以尝试以下步骤：

1. 检查Pod状态：`kubectl describe pod <pod-name>`
2. 查看Pod日志：`kubectl logs -f <pod-name>`
3. 检查Secret和ConfigMap是否正确创建：`kubectl get secrets` 和 `kubectl get configmaps`
4. 进入容器内部排查：`kubectl exec -it <pod-name> -- /bin/sh`

resource "aws_eks_cluster" "nikhil-cluster" {
name = var.cluster_name
role_arn = "arn:aws:iam::559050250964:role/eks_cluster"
vpc_config {
subnet_ids = var.subnet_ids
}
}
output "cluster_name" {
value = aws_eks_cluster.nikhil-cluster.name
}
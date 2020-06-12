#k8s cluster
resource "aws_eks_cluster" "project_k8s_cluster" {
  name     = var.k8s_cluster_name
  role_arn = aws_iam_role.project_cluster_iam_role.arn

  vpc_config {
    security_group_ids = [aws_security_group.progect_sg_cluster.id]
    subnet_ids         = "${var.private_subnet_ids}"
  }

  depends_on = [
    aws_iam_role_policy_attachment.cluster-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.cluster-AmazonEKSServicePolicy,
  ]

  tags = {
    Environment = "${var.env}"
    Project     = "${var.project}"
  }
}

#k8s worker nodes
resource "aws_eks_node_group" "project" {
  cluster_name    = aws_eks_cluster.project_k8s_cluster.name
  node_group_name = "${var.project}-nodes"
  node_role_arn   = aws_iam_role.project_node_role.arn
  subnet_ids      = "${var.private_subnet_ids}"
  instance_types  = "${var.type_instance}"

  scaling_config {
    desired_size = 2
    max_size     = 2
    min_size     = 2
  }

  depends_on = [
    aws_iam_role_policy_attachment.project_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.project_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.project_AmazonEC2ContainerRegistryReadOnly,
  ]

  tags = {
    Environment = "${var.env}"
    Project     = "${var.project}"
  }
}

#security group for k8s cluster
resource "aws_security_group" "progect_sg_cluster" {
  name        = "${var.project} K8S CLUSTER SG"
  description = "Cluster communication with worker nodes"
  vpc_id      = "${var.vpc_id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Environment = "${var.env}"
    Project     = "${var.project}"
  }
}

#iam role and policy for nodes
resource "aws_iam_role" "project_node_role" {
  name = "eks_node_iam_role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY

  tags = {
    Environment = "${var.env}"
    Project     = "${var.project}"
  }
}

resource "aws_iam_role_policy_attachment" "project_AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.demo-node.name
}

resource "aws_iam_role_policy_attachment" "project_AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.demo-node.name
}

resource "aws_iam_role_policy_attachment" "project_AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.demo-node.name
}

#iam role and policy for cluster
resource "aws_iam_role" "project_cluster_iam_role" {
  name = "eks_cluster_iam_role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY

  tags = {
    Environment = "${var.env}"
    Project     = "${var.project}"
  }
}

resource "aws_iam_role_policy_attachment" "cluster-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.demo-cluster.name
}

resource "aws_iam_role_policy_attachment" "cluster-AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.demo-cluster.name
}

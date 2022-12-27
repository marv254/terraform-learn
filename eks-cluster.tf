module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.4.2"


cluster_name = "myapp-eks-cluster"
cluster_version = "1.24"

subnet_ids = module.myapp-vpc.private_subnets
vpc_id = module.myapp-vpc.vpc_id

cluster_endpoint_public_access = true

tags = {
    environment = "development"
    application = "myapp"
}
  eks_managed_node_groups = {
    dev = {
      min_size     = 1
      max_size     = 6
      desired_size = 3

      instance_types = ["t2.small"]
    }
  }
}
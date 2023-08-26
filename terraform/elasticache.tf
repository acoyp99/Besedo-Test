resource "aws_elasticache_cluster" "elasticache-cluster" {
  cluster_id           = "redis-cluster"
  engine               = "redis"
  node_type            = "cache.t2.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis5.0"
  engine_version       = "5.0.6"
  port                 = 6379
  subnet_group_name    = aws_elasticache_subnet_group.default.name
  security_group_ids   = [aws_security_group.elasticache_sg.id]
}

resource "aws_elasticache_replication_group" "example" {
  replication_group_id          = "elasticache-replication-group"
  replication_group_description = "Project replication group"
  node_type                     = "cache.t2.micro"
  number_cache_clusters         = 2
  engine                        = "redis"
  engine_version                = "5.0.6"
  parameter_group_name          = "default.redis5.0"
  port                          = 6379
  subnet_group_name             = aws_elasticache_subnet_group.default.name
  security_group_ids            = [aws_security_group.elasticache_sg.id]

  automatic_failover_enabled    = true
  auto_minor_version_upgrade    = true
}

resource "aws_elasticache_subnet_group" "default" {
  name       = "elasticache-subnet-group"
  subnet_ids = [aws_subnet.private.id]

  description = "An example Elasticache subnet group"
}

# hackaton GEMINI 21/04/2026

## deficiencias a detectar

- región no europea
- IP pública
- SSH abierto a 0.0.0.0/0
- puertos 80, 443, 8080, 3306 abiertos
- egress total
- disco sin cifrar
- IMDSv1 permitido
- password auth en SSH
- credenciales hardcodeadas
- secretos en user_data
- naming/tagging pobres
- gp2 en vez de opciones más modernas
- sin referencia a backups, monitoring, IAM mínimo, etc.


## Batería de reglas para que tu agente detecte más cosas


- Red y exposición
- 0.0.0.0/0 en puertos sensibles: 22, 3389, 3306, 5432, 6379, 9200
- subnet pública para cargas que deberían ser privadas
- IP pública asociada por defecto
- sin WAF / sin LB / acceso directo a instancia
- Cifrado y secretos
- volúmenes sin cifrado
- secretos hardcodeados en variables o locals
- secretos en user_data
- claves privadas embebidas en ficheros
- outputs que exponen credenciales
- Identidad y permisos
- políticas IAM con "Action": "*" y "Resource": "*"
- uso de admin policies
- instancia sin rol dedicado o con rol excesivo
- trust policies demasiado amplias
- Observabilidad y operación
- sin CloudWatch / logging
- sin alarmas
- sin backup policy
- sin patching
- sin SSM agent / sin acceso seguro de administración
- Resiliencia
- todo en una sola AZ
- sin autoscaling
- disco muy pequeño
- sin health checks
- sin recuperación automática
- Gobernanza
- tags incompletos
- nombres poco descriptivos
- región no permitida por policy
- recursos fuera de estándar corporativo
- versiones sin pinning o demasiado laxas
- Terraform específico
- provider sin versionado estricto
- uso excesivo de defaults inseguros
- variables sensibles sin sensitive = true
-   outputs de datos sensibles
- lifecycle ignorando cambios críticos
- módulos no fijados por versión/commit
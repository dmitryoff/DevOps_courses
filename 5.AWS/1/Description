1. Create vpc
даём только имя, все настройки default

2. Create Internet gateway
Приаттачиваем созданный  igw к нашему vpc (в поле state должен быть статус attached)

3. Create subnet
Создаём 3 подсети в нашем vpc с нужной нам зоной. Подсеть по умолчанию приватная. Если хотим сделать её публичной то в Modify auto-assign IP settings ставим галочку.

4. Route table для private и public subnets делаем разный, т.к. приватная подсеть идёт через NAT gw.

5. Create ACL
Через subnet associations добавляем нашу подсеть. Deny говорит нам о том что доступ ограничен.
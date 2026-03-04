## Task 1

[vpc module](./vpc_dev/)

[main.tf](main.tf)

[route table](route-table.tf)

### Доступ в итернет из публичного хоста

![alt text](./images/0.png)

### Доступ в итернет из приватного хоста (не понятно, почему в первом задании не указано, что NAT адресс у 192.168.10.254 должен быть, иначе из приватной подсети нет доступа в интернет)

```
ssh -J ubuntu@89.169.131.145 ubuntu@192.168.20.19

```

![alt text](./images/1.png)

![alt text](./images/2.png)

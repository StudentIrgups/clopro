<style>
  img {
    border: 2px solid #ccc;
    padding: 5px;
    border-radius: 5px;
    box-shadow: 2px 2px 5px rgba(0,0,0,0.3);
  }
</style>
## Task 1

### 1.1

[object-storage.tf](./object-storage.tf)

![alt text](./images/0.png)

![alt text](./images/1.png)

### 1.2

Создал новое хранилище с веб-сайтом и https:

![alt text](./images/2.png)

Добавил [сертификат](./certificate/main.tf). 

![alt text](./images/3.png)

При крепил его в хранилищу:

![alt text](./images/4.png)

![alt text](./images/5.png)

Но, однако, при открытии моего веб-сайта сертификат подтягивается от яндекса, не мой:

![alt text](./images/6.png)





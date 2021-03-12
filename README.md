## to start the project please follow the below commands

- db create ``` rails db:create```

- db migrate ```rails db:migrate```

- db init data ```rails db:seed```

start the program 

``` rails s```


regex 

Mon-Sun 11:30 am - 9 pm

Mon-Sun 11:30 am - 9:12 pm

```
/^(\w{3,5}[-]\w{3,5}\s\d{1,2}[:]*[\d{1,2}]*\s\w{2}\s[-]\s\d{1,2}[:]*[\d{1,2}]*\s\w{2})/
```


Tues - Weds, Fri 11 pm - 2:45 pm

Mon -  Thu,  Sun 11:30 am - 9 pm 

```
/^(\w{3,4}\s*[-]\s*\w{3,5}[,]\s*\w{3,5}\s*\d{1,2}[:]*[\d{1,2}]*\s\w{2}\s[-]\s\d{1,2}[:]*[\d{1,2}]*\s\w{2})/
```


Sun 10 am - 11 pm

```
/^(\w{3,5}[\s]*\d{1,2}[:]*[\d{1,2}]*[\s]\w{2}[\s]*[-][\s]*\d{2}[:]*[\d{1,2}]*[\s]*\w{2})/
```




Mon, Thurs, Sat 7:15 am - 8:15 pm

```
^(?:[a-zA-Z0-9 ]+,)*[a-zA-Z0-9 ]+[\s\d{1,2}][:][\d{1,2}]*[\s]*\w{2}[\s]*[-][\s]*\w{1,2}[:][\w{1,2}]*[\s]*\w{2}
```
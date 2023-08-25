# devops.technical-tests.provisioning

Using the following yaml data structure and the provisioning tool of your choice, define the following tasks:

```yaml
---
user_accounts:
    marwa.faik:
        name: Marwa FAIK
        mail: marwa.faik@besedo.com
        position: DevOps Engineer
        office: Paris
        login: marwa.faik
        passwd: 1dd249r32DD
        groups: ['sudo','adm']
        ssh_keys: "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDC/Sz5UCUjCsxHth7jVKY6JidcAa48CFi9K0Fn/zxlVirnpHn+W/Tole1wq8ZWewy5aobfrfrObFSEJq1Mn/RP8XJY2YapzRMvG21+uJwaAdr6DRM41VYT1THNR8lUPjL6/WknFIN8oWodhRpoPpQC98GKRJlbRs2nLoUlN/rU1/FbA1zlStMS4im7txedyrQjWI8lGIBKEQ3BuFrbrnzdl1Mcc9YaVkLKs6lRt54I74/BbOZ3wf+GUD/HHmWPfxi/LylUYpgTvvWjYqHtZdWPA4ob8DCYkfNe5ZpM+Mqf/QOFn6vDoYY8ySaIyQf+8VHQMmaNI3m3e/fk+KoeWAdOChMHjcTflQBikDOTzBvaaKX9Wk2iBZcB/FCAKWu5JS8l9m6AyXLp5CUWw5zQ6jEfTe6cqoqdtoHuZiomNbQyMFcD6xFN3DUK4XzkDotYjkGI6LxnGWRBv3rMxe8mh/qgOYlzmunjqznxrxztFLMp5XMhrIE2PqWcXJqjIWcW+VhZEaBgW/ogloX2NkaF3cCCux4R/f3IGl4U29oMOqB7iHPwkoSOpOEaDg61vld4NTbBGKw/Muox45J0qDCczIlMtqqoQmehaVBBYu/2M7P0Z2KGNITrxMPcGFOp1qYFEB5w8j1l+ID/dWmt66qaeXNNQhdBxOVo2wpk7EKe38kuuQ=="
    gautier.casteur:
        name: Gautier CASTEUR
        mail: gautier.casteur@besedo.com
        position: DevOps Engineer
        office: Paris
        login: gautier.casteur
        passwd: odjow40fB#!123
        groups: ['sudo']
        ssh_keys: "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDddf8CIIf9GuXlmv1mu97C5tbllh9EZjnVtrNP2N9dM3xlyQ4ye63j69Ow5Wb281XIv20DRs8bsQV+4zFXycDMAbula1qHMQazpQ1VNqbBfrgSnV/2apnSCww01MxZwdaW2knQrc0h5dKLhQFCA4qcLuQzq4Gm3AWiKulsdJg6F8hFqVgGXcOjK6gGPuXPX2OAoS198B+YM9SEPLvrBPmGDFia25mAITiC9I11cvYOyfehnevLjRqAgThdAH2h6rcLtTV2KOvuIctR2Yycivy+izk6owqyWE9g8Er4bopbPY8pgsaTjbnM4/KxiCULrnQQFSm30ZdtaXVR8Q1wZYDCDS1lT7SOzVI1nGBpV7Pkd5lB1Rcl+58tAXpGzxEko6lv2HMiyvwJ1RMG7XPA3v823zCSFkKPlz94R0KUAwbJ5ZiTeTeDGc/X6klcuhljXOX8akmNMTzvSmsAYw0UkYQn/n05Gp2+VZd6VUEjxppLWQSLx5qTjMSTjDqKZAIbbJNn62d38YQlhw0a+dlUcylQe5DEzsaHAAY3NmeeoW0UjILEWd+ye6cFFIaBWMZs47E/zKTmzSUqizBysHrQTj2/qFWt0KQ0UEv3ekE/P7M5Op2mDLJ7Hvx89YDcoUGdyryut7iWRytajHMk/yMPet73hj2s2AQukjq21yW9cDrtkw=="
    evens.solignac:
        name: Evens SOLIGNAC
        mail: evens.solignac@besedo.com
        position: Lead DevOps Engineer
        office: France
        login: evens.solignac
        passwd: ClVJD5h6A0qPrMXq
        groups: ['sudo']
        ssh_keys: "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDV0RkjfsZu+GYxupMBKyAxK+vxobf93MpLtR6sYon3bt51gGrTUl9szRfT8DSVi+xqXOg/Vzov0sJsw/ctRhZfUjVVRB3yyZAr1y3tbPt4de8NsWJDDOCGXma6nT/Sqwbjd8rMDAkIqeZ0HKXyMFktduDSDYq3evVbPP9kGNWlclUdhTUCx8IZXamoGnBoHSXT6Cptxs48r6XD21lKmxYpaCXhl5EBdNY8Njn7iyOTaW/REsFU975JhBVgb6+ckCjnIdGIWAp+oq9phDEifLp0nhQKdCSc6fdSYa4KiAGfKCg0mlftHz+zA88jTcoBDNRSsZIYe1eTAsAqaXd7TWOEOH+qet+qKt9APnJR0zBgCZyZNceruuoOe0AnBfvgzAhGBKHEOe+rdWTDg3/boFmfuxwa/lKBn0mO5NP0v5xaGQtKdnMpktz+Ye5MN/wtnKDYIdM76XIewN1NIdRK1Kr3p9C8CKDm/dWhNrEBum6W/UY7Mz1DOAmFw6FlerWRonQOt1zAizxBaajS2T9g/6UlPOaS3Wv1xeiK8Wvg5O6krFFg3zJk3p6O+nuNnMNqS7JPeyoByNXK9l7xY/bEZYpSHryjFRvfy5jVcBassz6B2IpUFp3FX+ljuBG/qHoZxgd5dquqT0Iux2KurCIxgDBMF6RgZ+sZ1zG+3KvAskMsow=="
```

- Change the system open file limit to `65536` for the `root` user.
- Create all users accounts contained in the yaml data structure;
    - Users must be able to login with their `login` using their `ssh_keys`
    - Users must be part of the mentionned `groups`.
    - An `info` file in their `/home/USER/info` must contain the following informations : `name`, `position` & `office`.
- Install the `docker` package and then
    - Run a given container : `public.ecr.aws/q0x2y8f9/nginx-demo` – default exposed port is `55000`
    - Name the container `happy_roentgen`
- Download and copy the following [file – prrtprrt.txt](https://gist.githubusercontent.com/slgevens/aa9a2fc52cb5fef8b41c1b11a8b7d3e3/raw/dc1e3e288967bd4818277e4688d1daf615225337/prrtprrt.txt)
    - In each users `home/USER/prrtprrt.txt`
    - Locally (on your computer) in the working directory `$CURRENT_DIR/files/prrtprrt.txt`
- Encrypt sensitive data
    - Modify the yaml data structure and encrypt each users `passwd`
    - __Provide the encryption key__
- Use a role or a class install `nginx`
    - Expose the port `80` FORWARDING REQUESTS to the container `happy_roentgen`

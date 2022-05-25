# Local Load Surveys

> ## Caso de sucesso
1.  Sistema solicita os dados das enquetes do Cache
2.  Sistema entrega os dados das enquetes

> ## Exceção - Erro ao carregar dados do Cache
3.  Sistema retorna uma mensagem de erro inesperado

> ## Exceção - Cache vazio
4.  Sistema retorna uma mensagem de erro inesperado

---

# Local Validate Surveys

> ## Caso de sucesso
5.  Sistema solicita os dados das enquetes do Cache
6.  Sistema valida os dados recebidos do Cache

> ## Exceção - Erro ao carregar dados do Cache
7.  Sistema limpa os dados do cache

> ## Exceção - Dados inválidos no cache
8.  Sistema limpa os dados do cache

---

# Local Save Surveys

> ## Caso de sucesso
9.  Sistema grava os novos dados no Cache

> ## Exceção - Erro ao gravar dados no Cache
10.  Sistema retorna uma mensagem de erro inesperado
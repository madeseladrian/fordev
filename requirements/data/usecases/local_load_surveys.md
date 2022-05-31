# Local Load Surveys

> ## Caso de sucesso
1. ✅ Sistema solicita os dados das enquetes do Cache
2. ✅ Sistema entrega os dados das enquetes

> ## Exceção - Cache vazio
3. ✅ Sistema retorna uma mensagem de erro inesperado

> ## Exceção - Erro ao carregar dados do Cache
4. ✅ Sistema retorna uma mensagem de erro inesperado se os dados do cache são inválidos
5. ✅ Sistema retorna uma mensagem de erro inesperado se os dados do cache são incompletos
6. ✅ Sistema retorna uma mensagem de erro inesperado se o cache falha


---

# Local Validate Surveys

> ## Caso de sucesso
1. ✅ Sistema solicita os dados das enquetes do Cache
2. Sistema valida os dados recebidos do Cache

> ## Exceção - Erro ao carregar dados do Cache
3. Sistema limpa os dados do cache

> ## Exceção - Dados inválidos no cache
4. Sistema limpa os dados do cache

---

# Local Save Surveys

> ## Caso de sucesso
1. Sistema grava os novos dados no Cache

> ## Exceção - Erro ao gravar dados no Cache
2. Sistema retorna uma mensagem de erro inesperado
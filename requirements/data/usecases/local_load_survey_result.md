# Local Load Survey Result

> ## Caso de sucesso
1. ✅ Sistema solicita os dados do resultado de uma enquete do Cache
2. ✅ Sistema entrega os dados do resultado da enquete

> ## Exceção - Cache vazio
3. ✅ Sistema retorna uma mensagem de erro inesperado

> ## Exceção - Erro ao carregar dados do Cache
4. ✅ Sistema retorna uma mensagem de erro inesperado se os dados do cache são inválidos
5. Sistema retorna uma mensagem de erro inesperado se os dados do cache são incompletos
6. Sistema retorna uma mensagem de erro inesperado se o cache falha

---

# Local Validate Survey Result

> ## Caso de sucesso
1. Sistema solicita os dados do resultado de uma enquete do Cache
2. Sistema valida os dados recebidos do Cache

> ## Exceção - Dados inválidos no cache
3. Sistema limpa os dados do cache

> ## Exceção - Erro ao carregar dados do Cache
4. Sistema limpa os dados do cache

---

# Local Save Survey Result

> ## Caso de sucesso
1. Sistema grava os novos dados no Cache

> ## Exceção - Erro ao gravar dados no Cache
2. Sistema retorna uma mensagem de erro inesperado
# Remote Load Surveys

> ## Caso de sucesso
1. ✅ Sistema faz uma requisição para a URL da API de surveys
2. Sistema valida os dados recebidos da API
3. Sistema entrega os dados das enquetes

> ## Exceção - URL inválida
4. Sistema retorna uma mensagem de erro inesperado

> ## Exceção - Acesso negado
5. Sistema retorna uma mensagem de acesso negado

> ## Exceção - Resposta inválida
6. Sistema retorna uma mensagem de erro inesperado

> ## Exceção - Falha no servidor
7. Sistema retorna uma mensagem de erro inesperado

> ## Sucesso - Decoratee
8. Sistema valida o token de acesso para saber se o usuário tem permissão para ver esses dados
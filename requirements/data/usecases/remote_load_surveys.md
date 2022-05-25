# Remote Load Surveys

> ## Caso de sucesso
1. ✅ Sistema faz uma requisição para a URL da API de surveys
2. ✅ Sistema entrega os dados das enquetes
3. ✅ Sistema valida os dados recebidos da API

> ## Exceção - Resposta inválida (200)
4. ✅ Sistema retorna uma mensagem de erro inesperado

> ## Exceção - URL inválida (404)
5. ✅ Sistema retorna uma mensagem de erro inesperado

> ## Exceção - Falha no servidor (500)
6. ✅ Sistema retorna uma mensagem de erro inesperado

> ## Exceção - Acesso negado (403)
7. ✅ Sistema retorna uma mensagem de acesso negado

> ## Sucesso - Decoratee
8. Sistema valida o token de acesso para saber se o usuário tem permissão para ver esses dados
# Remote Load Survey Result

> ## Caso de sucesso
1. ✅ Sistema faz uma requisição para a URL da API de survey result
2. ✅ Sistema valida o token de acesso para saber se o usuário tem permissão para ver esses dados
3. ✅ Sistema valida os dados recebidos da API
4. ✅ Sistema entrega os dados do resultado da enquete

> ## Exceção - Resposta inválida
5. ✅ Sistema retorna uma mensagem de erro inesperado

> ## Exceção - URL inválida
6. ✅ Sistema retorna uma mensagem de erro inesperado

> ## Exceção - Acesso negado
7. ✅ Sistema retorna uma mensagem de acesso negado

> ## Exceção - Falha no servidor
8. Sistema retorna uma mensagem de erro inesperado
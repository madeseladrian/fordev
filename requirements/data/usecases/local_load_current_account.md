# Local Load Current Account Use Case

> ## Caso de sucesso
1. ✅ Sistema solicita o token de acesso do usuário gravado no Cache Seguro
2. ✅ Sistema retorna os dados da conta do usuário

> ## Exceção - Falha ao carregar dados do cache
3. Sistema retorna uma mensagem de erro inesperado
4. Sistema retorna uma mensagem de erro caso o token seja nulo
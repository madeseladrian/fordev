# Authorize Http Client Decorator

> ## Sucesso
1. ✅ Obter o token de acesso do Cache
2. ✅ Executar o request do HttpClient que está sendo decorado com um novo header (x-access-token)
3. ✅ Retornar a mesma resposta do HttpClient que está sendo decorado

> ## Exceção - HttpClient retornou alguma exceção (menos Forbidden)
4. ✅ Retornar a mesma exceção recebida

> ## Exceção - Falha ao obter dados do cache
5. ✅ Retornar erro HTTP Forbidden - 403
6. ✅ Apagar token de acesso do Cache

> ## Exceção - HttpClient retornou erro Forbidden
7. ✅ Retornar erro HTTP Forbidden - 403
8. ✅ Apagar token de acesso do Cache
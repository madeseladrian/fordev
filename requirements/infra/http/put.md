# HTTP Put

> ## Sucesso
1. ✅ Request com verbo http correto (put)
2. ✅ Passar nos headers o content type JSON
3. ✅ Chamar request com body correto
4. ✅ Ok - 200 e resposta com dados
5. ✅ Ok - 200 e sem body
6. ✅ No content - 204 e resposta sem dados
7. ✅ No content - 204 e resposta com dados

> ## Erros
8.  Bad request - 400 with body
9.  Bad request - 400
10. Unauthorized - 401
11. Forbidden - 403
12. Not found - 404
13. Internal server error - 500

> ## Exceção - Status code diferente dos citados acima
12. Internal server error - 500

> ## Exceção - Http request deu alguma exceção
13. Internal server error - 500

> ## Exceção - Verbo http inválido
0*. Internal server error - 500
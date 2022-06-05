# HTTP Put

> ## Sucesso
1. ✅ Request com verbo http correto (put)
2. ✅ Passar nos headers o content type JSON
3. ✅ Chamar request com body correto
4. ✅ Ok - 200 e resposta com dados
5. No content - 204 e resposta sem dados

> ## Erros
6. Bad request - 400
7. Unauthorized - 401
8. Forbidden - 403
9. Not found - 404
10. Internal server error - 500

> ## Exceção - Status code diferente dos citados acima
11. Internal server error - 500

> ## Exceção - Http request deu alguma exceção
12. Internal server error - 500

> ## Exceção - Verbo http inválido
0*. Internal server error - 500
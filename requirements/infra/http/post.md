# HTTP Post

> ## Sucesso
1. ✅ Request com verbo http correto (post)
2. ✅ Passar nos headers o content type JSON
3. ✅ Chamar request com body correto
4. Ok - 200 e resposta com dados
5. Ok - 200 e sem body
6. No content - 204 e resposta sem dados
7. No content - 204 e resposta com dados

> ## Erros
8. Bad request - 400 with body
9. Bad request - 400
10. Unauthorized - 401
11. Forbidden - 403
12. Not found - 404
13. Internal server error - 500

> ## Exceção - Status code diferente dos citados acima
14. Internal server error - 500

> ## Exceção - Http request deu alguma exceção
15. Internal server error - 500

> ## Exceção - Verbo http inválido
16. Internal server error - 500
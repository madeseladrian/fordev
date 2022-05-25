# HTTP Get

> ## Sucesso
1. ✅ Request com verbo http correto (get)
2. ✅ Passar nos headers o content type JSON
3. ✅ Ok - 200 e resposta com dados
4. ✅ No content - 204 e resposta sem dados

> ## Erros
5. ✅ Bad request - 400
6. ✅ Unauthorized - 401
7. ✅ Forbidden - 403
8. ✅ Not found - 404
9. ✅ Internal server error - 500

> ## Exceção - Status code diferente dos citados acima (422)
10.✅ Internal server error - 500

> ## Exceção - Http request deu alguma exceção
11. Internal server error - 500

> ## Exceção - Verbo http inválido
0. Internal server error - 500
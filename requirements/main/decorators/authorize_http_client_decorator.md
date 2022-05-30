# Authorize Http Client Decorator

> ## Caso de sucesso
1. ✅ Chamar o FetchSecureCacheStorage com a chave correta
2. ✅ Chamar o decoratee com o token de acesso no header
3. ✅ A resposta do HttpClient tem que retornar a mesma resposta do decoratee

> ## Erros
4. ✅ Retornar o ForbiddenError se o FetchSecureCacheStorage falhar
5. ✅ Repassar o erro do tipo HttpError adiante se o decoratee falhar, para que a classe que o chamou faça o tratamento adequado
6. Deletar o cache se o request retorna um ForbiddenError
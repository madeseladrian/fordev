# Remote Load Surveys With Local Fallback

> ## Caso de sucesso
1. ✅ Sistema executa o load da implementação remota
2. ✅ Sistema substitui os dados do Cache com os dados obtidos
3. Sistema retorna esses dados

> ## Exceção - Acesso negado
4. Sistema repassa a exceção de acesso negado

> ## Exceção - Qualquer outro erro
5. Sistema executa o método de validar dados do cache
6. Sistema executa o método de carregar dados do cache
7. Sistema retorna esses dados

> ## Exceção - Erro ao obter dados do Cache
8. Sistema retorna uma exceção de erro inesperado
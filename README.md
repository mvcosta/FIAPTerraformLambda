# Função Lambda de Autenticação via CPF e Geração de JWT

Esta função AWS Lambda, escrita em Python, autentica clientes usando o CPF. Uma vez autenticados, ela gera e retorna um token JWT (JSON Web Token) para o cliente. Esse token pode ser utilizado para acessar uma API .Net 6, proporcionando uma autenticação e autorização seguras dos usuários. O processo de CI/CD é realizado automaticamente através do GitHub Actions.

## Características

- **Autenticação via CPF**: Verifica a validade e autenticidade do CPF do cliente.
- **Geração de JWT**: Retorna um JWT para clientes autenticados.
- **Integração com API .Net 6**: O token gerado é compatível e pronto para ser usado com uma API .Net 6.
- **CI/CD via GitHub Actions**: Integração contínua e entrega contínua automatizadas.



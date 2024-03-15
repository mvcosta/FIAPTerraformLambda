# Função Lambda de Autenticação via CPF e Geração de JWT

Esta função AWS Lambda, escrita em Python, autentica clientes usando o CPF. Uma vez autenticados, ela gera e retorna um token JWT (JSON Web Token) para o cliente. Esse token pode ser utilizado para acessar uma API .Net 6, proporcionando uma autenticação e autorização seguras dos usuários. O processo de CI/CD é realizado automaticamente através do GitHub Actions.

## Características

- **Autenticação via CPF**: Verifica a validade e autenticidade do CPF do cliente.
- **Geração de JWT**: Retorna um JWT para clientes autenticados.
- **Integração com API .Net 6**: O token gerado é compatível e pronto para ser usado com uma API .Net 6.
- **CI/CD via GitHub Actions**: Integração contínua e entrega contínua automatizadas.

## Como iniciar a lambda de autenticação

Antes de se inicializer a lambda é necessário que o cluster [EKS](https://github.com/mvcosta/FIAPTerraformEKS) esteja de pé, pois a lambda será criada dentro da mesma VPC criada durante a criação do cluster.

A inicialização da lambda pode ser realizada de duas formas:

### 1. Realizar o fork do repositório

1. Faça o fork deste repositório.
2. Configure a autenticação do Github Actions utilizando OpenID Connec, seguindo o seguinte [tutorial](https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services).
3. Execute a action "Terraform".

### 2. Realizando o clone para sua máquina
1. Faça o clone do repositório na sua máquina.
2. Instale o terraform.
3. Instale a AWS CLI.
4. Realize a autenticação na AWS CLI.
5. Execute o seguinte comando na raiz desse projeto:
   ```
   chmod +x ./gen_zip.sh
   ./gen_zip.sh
   ```
7. Execute o comando `terrafom apply` dentro da pasta terraform

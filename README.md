# flutter_task_list

Um projeto da disciplina de Programação de dispositivos móveis!

## Instruções para executar

Executar `git clone https://github.com/MaironLucas/flutter_task_list`;
Executar `git checkout master`;
Executar `git pull`;
Executar `flutter pub get`;
Abrir um emulador de android, preferencialmente com a API 30 e na dimensão **1080x1920**;
Executar `flutter run`;

## Qual o objetivo do app?

O App será uma ferramenta para criação e compartilhamento de listas de tarefas (sejam essas atividades do dia a dia ou compras de mercado, por exemplo). Primeiramente, o usuário terá que realizar um cadastro utilizando email e nome. Tendo logado, ele será capaz de, na página inicial, criar novas listas e visualizar as listas já criadas. Quando uma lista é clicada, a página de detalhes dela irá abrir onde será possível tanto adicionar produtos a ela quanto compartilhar essa lista com outro usuário. O compartilhamento será feito através da geração de um QR Code que será lido pela pessoa com a qual a lista será compartilhada. Dessa forma, ambos os usuários poderão editar uma mesma lista.

## O que foi implementado nesse envio?

Nesse envio, focamos na implementação dos principais formulários que estarão presentes no app, os formulários de inscrição e login. Foi feito todo o design utilizando de componentes do Flutter, assim como a validação. Para esse envio, como ainda não deveria incluir banco de dados, as informações são armazenadas somente durante a execução do app em uma classe chamada DummyStateHandler. Quanto a estruturação do projeto, utilizamos o padrão MVC com algumas modificações: Teremos classes repositorys e data sources (uma para cache, outra para acesso remoto, essas classes que de fato fazem a comunicação com os bancos), assim como o uso da arquitetura BloC no lugar dos controllers. O BloC é implementado utilizando o package RxDart. Além disso, implementamos o conceito de Injeção de Dependências através do uso do package Provider.
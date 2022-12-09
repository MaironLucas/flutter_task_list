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

Nesse envio, alteramos a cor principal dos botões e alguns itens, como sugerido pelo professor no último envio. Além disso, tornamos as preferências do usuário (tema e ordenação da lista) atributos salvos no cache através do Hive. 

Com relação à implementação de recurso nativo, implementamos a possibilidade do usuário compartilhar sua Task com outros através de um QR Code que pode ser scanneado pelo recurso de câmera também disponível no app (adicionando assim a respectiva Task a lista de Tasks do usuário que leu o QR Code).

Com relação a API, utilizamos a API disponível em https://github.com/akabab/starwars-api. Através dessa API, toda vez que o usuário acessa a página de configurações ele terá a foto de um personagem diferente da saga Star Wars, assim como o nome desse personagem como "apelido". A lista de personagens é obtida uma única vez e armazenada em uma box do Hive, tornando assim o acesso a essas informações mais rápido.

## Como as atividades foram divididas?
O grupo fez as implementações em conjunto.
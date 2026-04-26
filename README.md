# FitConnect

> Projeto de exemplo para a série **"Deep Links em Flutter — Do Zero à Produção"**

![Flutter](https://img.shields.io/badge/Flutter-3.10%2B-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.0%2B-0175C2?logo=dart)
![License](https://img.shields.io/badge/License-MIT-green)

Série completa no Medium: [Deep Links em Flutter — Do Zero à Produção](https://medium.com/@crdornelles)

---

## Sobre o projeto

**FitConnect** é um app fictício de networking para o setor fitness. A ideia central é simples: personal trainers compartilham um link de referral com seus alunos; quando um aluno se cadastra via link, o trainer ganha bônus e o aluno ganha desconto.

Este repositório existe por um único motivo: ser o código de referência para a série de posts sobre Deep Links em Flutter. Cada post da série corresponde a uma branch, para que você possa acompanhar a evolução do código passo a passo.

**Deep link principal:**

```
https://deeplinkslab.dev/signup?referralCode=TRAINER12345678901234
```

---

## Série de Posts

| #   | Título                                                      | Branch                 | Post                                                                                                                       |
| --- | ----------------------------------------------------------- | ---------------------- | -------------------------------------------------------------------------------------------------------------------------- |
| 1   | Deep Links em Flutter: O Guia Definitivo para Iniciantes    | `post/01-intro`        | [https://medium.com/@crdornelles/deep-links-em-flutter-o-guia-definitivo-para-iniciantes-parte-1-d56ea3619192]             |
| 2   | Implementando Deep Links Nativos no Android (Kotlin)        | `post/02-android`      | [https://medium.com/p/562bb353b3b2?postPublishedType=initial]                                                              |
| 3   | Deep Links Nativos no iOS: Custom Schemes e Universal Links | `post/03-ios`          | [https://medium.com/@crdornelles/deep-links-no-ios-implementa%C3%A7%C3%A3o-nativa-com-swift-flutter-parte-3-d37569fd0a15]  |
| 4   | Conectando Tudo: Integração Flutter com Deep Links Nativos  | `post/04-flutter`      | [https://medium.com/@crdornelles/conectando-tudo-integra%C3%A7%C3%A3o-flutter-com-deep-links-nativos-parte-4-b9b23c6e32e5] |
| 5   | App Links e Universal Links: Deep Links em Produção         | `post/05-producao`     | [https://medium.com/@crdornelles/app-links-e-universal-links-deep-links-em-produ%C3%A7%C3%A3o-parte-5-73ed0a186e75]       |
| 6   | Deferred Deep Links: Quando o Usuário Ainda Não Tem o App   | `post/06-deferred`     | [https://medium.com/p/f3388d58e49a?postPublishedType=initial]                                                              |
| 7   | Web Redirect: A Ponte Entre Navegador e App Store           | `post/07-web-redirect` | [em breve]                                                                                                                 |
| 8   | Testes, Deploy e Troubleshooting de Deep Links              | `post/08-testes`       | [em breve]                                                                                                                 |
| 9   | Refatoração: DeepLinkHandler com Clean Architecture         | `post/09-refatoracao`  | [em breve]                                                                                                                 |

---

## Como usar este repositório

**1. Clone o repositório**

```bash
git clone git@github.com:crdornelles/fit_connect.git
cd fit_connect
```

**2. Mude para a branch do post que está lendo**

```bash
git checkout post/02-android
```

**3. Instale as dependências e gere os arquivos do Freezed**

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

**4. Teste os deep links**

Android:

```bash
# Custom Scheme
adb shell am start -a android.intent.action.VIEW \
  -d "fitconnect://deeplinkslab.dev/signup?referralCode=TRAINER12345678901234"

# HTTPS (App Links)
adb shell am start -a android.intent.action.VIEW \
  -d "https://deeplinkslab.dev/signup?referralCode=TRAINER12345678901234"
```

iOS (simulador):

```bash
xcrun simctl openurl booted \
  "https://deeplinkslab.dev/signup?referralCode=TRAINER12345678901234"
```

---

## Estrutura do projeto

```
fitconnect/
├── android/          # Configuração nativa Android (AndroidManifest + MainActivity.kt)
├── ios/Runner/       # Configuração nativa iOS (Info.plist, entitlements, AppDelegate.swift)
├── lib/
│   ├── core/         # DeepLinkHandler (ChangeNotifier)
│   ├── services/     # DeepLinkService (MethodChannel + EventChannel)
│   ├── shared/       # Constantes, enums e modelos (Freezed)
│   └── modules/      # Telas do app (home, signup)
├── web_redirect/     # Página HTML de redirecionamento inteligente
└── .well-known/      # Arquivos de verificação (assetlinks.json, apple-app-site-association)
```

---

## Pré-requisitos

- Flutter 3.10+
- Android Studio (para builds Android) ou Xcode 14+ (para builds iOS)
- `adb` instalado e configurado para testes no Android

---

## Licença

MIT

# FitConnect

> Projeto de exemplo para a série **"Deep Links em Flutter — Do Zero à Produção"**

![Flutter](https://img.shields.io/badge/Flutter-3.10%2B-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.0%2B-0175C2?logo=dart)
![License](https://img.shields.io/badge/License-MIT-green)

Série completa no Medium: [em breve]

---

## Sobre o projeto

**FitConnect** é um app fictício de networking para o setor fitness. A ideia central é simples: personal trainers compartilham um link de referral com seus alunos; quando um aluno se cadastra via link, o trainer ganha bônus e o aluno ganha desconto.

Este repositório existe por um único motivo: ser o código de referência para a série de posts sobre Deep Links em Flutter. Cada post da série corresponde a uma branch, para que você possa acompanhar a evolução do código passo a passo.

**Deep link principal:**
```
https://fitconnect.app/signup?referralCode=TRAINER12345678901234
```

---

## Série de Posts

| # | Título | Branch | Post |
|---|--------|--------|------|
| 1 | Deep Links em Flutter: O Guia Definitivo para Iniciantes | `post/01-intro` | [em breve] |
| 2 | Implementando Deep Links Nativos no Android (Kotlin) | `post/02-android` | [em breve] |
| 3 | Deep Links Nativos no iOS: Custom Schemes e Universal Links | `post/03-ios` | [em breve] |
| 4 | Conectando Tudo: Integração Flutter com Deep Links Nativos | `post/04-flutter` | [em breve] |
| 5 | App Links e Universal Links: Deep Links em Produção | `post/05-producao` | [em breve] |
| 6 | Deferred Deep Links: Quando o Usuário Ainda Não Tem o App | `post/06-deferred` | [em breve] |
| 7 | Web Redirect: A Ponte Entre Navegador e App Store | `post/07-web-redirect` | [em breve] |
| 8 | Testes, Deploy e Troubleshooting de Deep Links | `post/08-testes` | [em breve] |
| 9 | Refatoração: DeepLinkHandler com Clean Architecture | `post/09-refatoracao` | [em breve] |

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
  -d "fitconnect://fitconnect.app/signup?referralCode=TRAINER12345678901234"

# HTTPS (App Links)
adb shell am start -a android.intent.action.VIEW \
  -d "https://fitconnect.app/signup?referralCode=TRAINER12345678901234"
```

iOS (simulador):
```bash
xcrun simctl openurl booted \
  "https://fitconnect.app/signup?referralCode=TRAINER12345678901234"
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

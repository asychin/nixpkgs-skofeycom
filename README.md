# nixpkgs-skofeycom

Монорепозиторий с личными Nix флейками. Каждый пакет - это отдельный независимый флейк.

[![NixOS](https://img.shields.io/badge/NixOS-ready-blue?logo=nixos)](https://nixos.org)

## 🎯 Концепция

Каждая директория в этом репозитории - это **отдельный флейк** для конкретного пакета. Это позволяет:
- Подключать только нужные пакеты
- Независимо обновлять каждый пакет
- Держать все флейки в одном месте
- Легко делиться отдельными пакетами

## 📦 Доступные флейки

### Waveterm
Современный терминальный эмулятор

```nix
{
  inputs.waveterm = {
    url = "github:asychin/nixpkgs-skofeycom?dir=waveterm";
    inputs.nixpkgs.follows = "nixpkgs";
  };
}
```

### Antigravity
Google Antigravity IDE (планируется)

```nix
{
  inputs.antigravity = {
    url = "github:asychin/nixpkgs-skofeycom?dir=antigravity";
    inputs.nixpkgs.follows = "nixpkgs";
  };
}
```

## 🚀 Использование

### NixOS Configuration

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    
    # Подключаем только нужные пакеты
    waveterm = {
      url = "github:asychin/nixpkgs-skofeycom?dir=waveterm";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, waveterm, ... }: {
    nixosConfigurations.your-hostname = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        waveterm.nixosModules.default
        {
          programs.waveterm.enable = true;
        }
      ];
    };
  };
}
```

### Home Manager

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    
    waveterm = {
      url = "github:asychin/nixpkgs-skofeycom?dir=waveterm";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, waveterm, ... }: {
    homeConfigurations.your-user = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      modules = [
        waveterm.homeManagerModules.default
        {
          programs.waveterm.enable = true;
        }
      ];
    };
  };
}
```

### Quick Run

```bash
# Запустить без установки
nix run github:asychin/nixpkgs-skofeycom?dir=waveterm

# Собрать
nix build github:asychin/nixpkgs-skofeycom?dir=waveterm
```

## 📂 Структура репозитория

```
nixpkgs-skofeycom/
├── README.md
├── waveterm/
│   ├── flake.nix
│   ├── package.nix
│   └── modules/
│       ├── nixos.nix
│       └── home-manager.nix
├── antigravity/
│   ├── flake.nix
│   ├── package.nix
│   └── modules/
│       ├── nixos.nix
│       └── home-manager.nix
└── ... (другие пакеты)
```

## ➕ Добавление нового пакета

1. Создай директорию для пакета:
```bash
mkdir my-package
cd my-package
```

2. Создай `flake.nix`:
```nix
{
  description = "My Package";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      packages = forAllSystems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.callPackage ./package.nix { };
          my-package = pkgs.callPackage ./package.nix { };
        }
      );

      nixosModules.default = import ./modules/nixos.nix;
      homeManagerModules.default = import ./modules/home-manager.nix;
    };
}
```

3. Создай `package.nix` с описанием пакета

4. Создай модули для NixOS и Home Manager (опционально)

## 🔧 Преимущества этого подхода

- ✅ **Модульность**: Каждый пакет независим
- ✅ **Гибкость**: Подключай только то, что нужно
- ✅ **Простота**: Вся коллекция в одном репозитории
- ✅ **Версионность**: Можно пинить разные версии разных пакетов
- ✅ **Чистота**: Не нужно тащить зависимости для ненужных пакетов

## 📝 Список пакетов

- [x] **waveterm** - Современный терминал
- [x] **antigravity** - Google Antigravity IDE

## 📄 License

MIT License

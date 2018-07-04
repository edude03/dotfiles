To install run:

```
nix-env -f zshrc.nix -i
# might need to rm ~/.zshrc first
ln -s "$(nix-env -q zshrc --out-path --no-name)" ~/.zshrc
```

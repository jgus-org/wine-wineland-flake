# wine-wineland

A Nix flake that builds [Wine Wineland](https://github.com/nanomatters/wine-salkim), a Wine fork with a graphics driver that presents Windows windows directly on a Wayland compositor, assembled on nixpkgs' Wow64 Wine flavour.

## Outputs

| Attribute                | What you get                                                                             |
| ------------------------ | ---------------------------------------------------------------------------------------- |
| `packages.default`       | A Wine installation: `wine`, `winecfg`, `wineserver` and the rest of the usual commands. |
| `packages.wine-wineland` | The same package under its own name.                                                     |
| `checks.wine-wineland`   | The package as a build check.                                                            |

Published for `x86_64-linux`.

## Requirements and notes

- On a Wayland session the compositor itself draws the Windows desktop. The presentation path has no X server and no XWayland. The X11 driver remains available for sessions that need it.
- The Wow64 build runs 32-bit Windows programs next to 64-bit ones.
- `WINEUSERNAME` names the Windows user that Wine's user-name APIs report. With it unset, they report the upstream fork's own default, so you only need to set it when the guest should see a different name.
- Wine fills its Windows certificate store from `NIX_SSL_CERT_FILE`. Set it to your CA bundle. With it unset, there is nothing to import on a system without the FHS certificate paths. Anything validating TLS through Windows APIs then rejects certificates the host would accept.
- Prefix state is ordinary Wine state: `$WINEPREFIX`, default `~/.wine`.

See [LICENSE.md](LICENSE.md) for licensing and copyright, and [NOTICE.md](NOTICE.md) for the terms of upstream and distributed artifacts.

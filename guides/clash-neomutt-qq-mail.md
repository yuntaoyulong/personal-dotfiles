# Clash Verge + NeoMutt + QQ Mail Core Idea

## Context
When Clash Verge runs in TUN + fake-ip mode, IMAP/SMTP can fail even if browser traffic works.
Typical symptoms:
- `mbsync`: malformed FETCH / sync hangs
- `msmtp`: TLS handshake failed
- DNS resolves QQ mail hosts to `198.18.x.x`

## Root Cause
`198.18.0.0/15` is fake-ip address space used by Clash-like DNS modes.
Mail protocols (IMAP/SMTP over TLS) are more sensitive to this indirection than HTTP.

## Stable Fix Pattern
1. Add QQ mail domains to fake-ip exclusion list:
- `imap.qq.com`
- `smtp.qq.com`
- `ex.qq.com`
- `+.qq.com`

2. Add direct rules at top (before generic rules):
- `DOMAIN,imap.qq.com,DIRECT` (or local direct group)
- `DOMAIN,smtp.qq.com,DIRECT`
- `DOMAIN,ex.qq.com,DIRECT`

3. Keep this logic in Clash Verge profile script hook so subscription updates do not erase it.

## Validation Commands
```bash
getent hosts imap.qq.com smtp.qq.com
mbsync -nV qq
echo -e "Subject: test\n\nhello" | msmtp -a qq aotianzhihuo@vip.qq.com
```

Expected:
- DNS should not be `198.18.x.x`
- `mbsync` can log in and reach `Synchronizing...`
- `msmtp` exits without TLS/resolve errors

## Rollback
If needed, restore from backup in:
`~/.local/share/io.github.clash-verge-rev.clash-verge-rev/`
with files named like `*.bak.YYYYmmddHHMMSS`.

## WeChat Add-on
If WeChat is used with Clash TUN/fake-ip, keep it direct as well:
- Rule level: `DOMAIN-SUFFIX,weixin.qq.com,DIRECT`, `DOMAIN-SUFFIX,wx.qq.com,DIRECT`, `DOMAIN-SUFFIX,wechat.com,DIRECT`
- DNS level (`fake-ip-filter`): `+.weixin.qq.com`, `+.wx.qq.com`, `+.wechat.com`

This prevents unstable login/message channels caused by fake-ip DNS mapping.

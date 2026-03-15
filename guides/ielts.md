# IELTS Workflow Guide (Persistent)

## Objective
Build a reusable English learning system where progress survives across new chat sessions.

## Single source of truth
- Progress state:
  - `/home/quaerendo/ielts_pack/09_tools/state/progress.json`
- Mistake history:
  - `/home/quaerendo/ielts_pack/05_mistakes/MISTAKE_LOG.md`
- Unknown words:
  - `/home/quaerendo/ielts_pack/09_tools/data/unknown_words.csv`

## Session start protocol (use this in any new chat)
Paste:

```text
Load my IELTS state from:
- /home/quaerendo/ielts_pack/09_tools/state/progress.json
- /home/quaerendo/ielts_pack/05_mistakes/MISTAKE_LOG.md
- /home/quaerendo/ielts_pack/09_tools/data/unknown_words.csv
Then continue from my last completed question and keep coaching in English.
```

## During study
1. Do questions.
2. For each mistake, log:
   - what I chose
   - evidence line
   - why correct is correct
   - why my option is wrong
3. Add unknown words with `word_add.sh`.

## After each question block
Update progress:
```bash
/home/quaerendo/ielts_pack/09_tools/bin/progress_update.sh <q_number> "<next_action>"
```

## Unknown words review (wofi)
```bash
/home/quaerendo/ielts_pack/09_tools/bin/word_review_wofi.sh
```

## Meaningful message in listening: diagnosis tags
Use these tags when reviewing listening misses:
- `sound segmentation`
- `accent/speed`
- `vocab gap`
- `syntax parse failure`
- `inference failure`
- `memory drop`
- `attention drop`

## Rule
No answer is accepted as "learned" without evidence mapping.

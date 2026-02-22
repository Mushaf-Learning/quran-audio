# EveryAyah URL Pattern

## Base URL

```
https://everyayah.com/data/{reciter_subfolder}/{surah}{ayah}.mp3
```

## File Naming Convention

Audio files use a **6-digit filename** composed of two zero-padded numbers:

| Component | Format | Range | Description |
|-----------|--------|-------|-------------|
| Surah | `SSS` | 001 - 114 | 3-digit zero-padded surah number |
| Ayah | `AAA` | 001 - 286 | 3-digit zero-padded ayah number (max varies by surah) |

Combined format: `SSSAAA.mp3`

## Examples

| Description | URL |
|-------------|-----|
| Al-Fatiha, Ayah 1 | `https://everyayah.com/data/Alafasy_128kbps/001001.mp3` |
| Al-Fatiha, Ayah 7 | `https://everyayah.com/data/Alafasy_128kbps/001007.mp3` |
| Al-Baqarah, Ayah 255 (Ayat al-Kursi) | `https://everyayah.com/data/Alafasy_128kbps/002255.mp3` |
| An-Nas, Ayah 6 (last ayah) | `https://everyayah.com/data/Alafasy_128kbps/114006.mp3` |
| Husary Muallim, Al-Fatiha Ayah 1 | `https://everyayah.com/data/Husary_Muallim_128kbps/001001.mp3` |

## Reciter Subfolders

The `{reciter_subfolder}` value corresponds to the `subfolder` field in `reciters/reciters.json`. Some subfolders include path separators for organized collections:

- Standard Arabic reciters: `Alafasy_128kbps`, `Husary_128kbps`, etc.
- Warsh qiraat: `warsh/warsh_ibrahim_aldosary_128kbps`, etc.
- Translations: `English/Sahih_Intnl_Ibrahim_Walk_192kbps`, `translations/urdu_shamshad_ali_khan_46kbps`, etc.

## Ayah Counts per Surah

The total number of ayahs per surah (needed to know when to stop downloading) is available in:
- `reciters/recitations.raw.js` (the `ayahCount` array)
- `reciters/reciters.json` does not include this; use the raw file or the hardcoded list in `scripts/download_reciter.sh`

For reference, the total across all 114 surahs is **6,236 ayahs**.

## Bismillah Handling

- Surah 1 (Al-Fatiha): Bismillah is Ayah 1 (`001001.mp3`)
- Surah 9 (At-Tawbah): No Bismillah
- All other surahs: Bismillah is recited at the start but the ayah numbering begins at 1 (the first actual ayah after Bismillah). EveryAyah includes the Bismillah as part of the first ayah audio for most reciters.

## Recitations Metadata

The full list of available reciters and their subfolder names can be found at:
```
https://everyayah.com/data/recitations.js
```

A local copy is saved at `reciters/recitations.raw.js` and a parsed version at `reciters/reciters.json`.

## Rate Limiting

Be respectful when downloading. The `download_reciter.sh` script includes a 100ms delay between requests. A full reciter download (6,236 files) takes approximately 15-20 minutes with this delay.

## File Sizes

Approximate total sizes per reciter (all 6,236 ayahs):

| Bitrate | Approximate Total Size |
|---------|----------------------|
| 32kbps | ~1.5 GB |
| 64kbps | ~3.0 GB |
| 128kbps | ~6.0 GB |
| 192kbps | ~9.0 GB |

Actual sizes vary by reciter due to differences in recitation speed.

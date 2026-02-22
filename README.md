# Quran Audio

Open-source Qari metadata, audio URL mappings, download scripts, and word-level timestamps for Quran audio resources.

## What's Included

### Qari Database
Metadata for 79+ reciters including:
- Name (Arabic/English)
- Audio quality (bitrate)
- Recitation style (Murattal, Mujawwad, Muallim)
- Qira'ah (Hafs, Warsh)
- Folder name for URL construction

### Priority Reciters

| Qari | Style | Quality | Folder |
|------|-------|---------|--------|
| Mishary Rashid Alafasy | Murattal | 128kbps | `Alafasy_128kbps` |
| Abdul Rahman Al-Sudais | Murattal | 192kbps | `Abdurrahmaan_As-Sudais_192kbps` |
| Abdul Basit Abdul Samad | Murattal | 192kbps | `Abdul_Basit_Murattal_192kbps` |
| Saad Al-Ghamdi | Murattal | 128kbps | `Saad_Al_Ghamdi_128kbps` |
| Maher Al-Muaiqly | Murattal | 128kbps | `MauroAl_Muaiqly_128kbps` |
| Mahmoud Khalil Al-Husary | Murattal | 128kbps | `Husary_128kbps` |
| Al-Husary (Muallim) | Teaching | 128kbps | `Husary_Muallim_128kbps` |

### Audio URL Pattern
```
https://everyayah.com/data/{FOLDER}/{SSS}{AAA}.mp3
```
- `SSS` = 3-digit surah number (001–114)
- `AAA` = 3-digit ayah number (001–286)
- Example: `https://everyayah.com/data/Alafasy_128kbps/001001.mp3` = Al-Fatiha, Ayah 1

### Word-Level Audio Timestamps
Millisecond-precision timing for each word synced to Qari audio. Enables word-by-word highlighting during playback.

### Download Scripts
Batch download tools for:
- Individual Surahs
- Full Juz
- Complete Quran per reciter

## Directory Structure

```
reciters/         # Qari metadata (JSON)
timestamps/       # Word-level audio timing data (JSON)
scripts/          # Download and processing scripts
```

## Data Sources & Attribution

- Ayah audio: [EveryAyah.com](https://everyayah.com)
- Reciter metadata: [EveryAyah recitations.js](https://everyayah.com/data/recitations.js)
- Word timestamps: [cpfair/quran-align](https://github.com/cpfair/quran-align) (CC BY 4.0)
- KSU Electronic Moshaf: [quran.ksu.edu.sa](https://quran.ksu.edu.sa)

## License

MIT — Free for personal and commercial use. See [LICENSE](LICENSE).

Audio files themselves are hosted by EveryAyah.com — this repo contains metadata and tools, not the audio files.

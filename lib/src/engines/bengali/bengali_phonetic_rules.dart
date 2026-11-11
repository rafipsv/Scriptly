import 'bengali_constants.dart';

/// Predefined tables and mappings for the Bengali phonetic engine.
class BengaliPhoneticRules {
  BengaliPhoneticRules._();

  /// Curated dictionary of common Banglish words and their authentic Bengali spellings.
  /// Keys are stored in lowercase for fast, case-insensitive lookups.
  static const Map<String, String> commonWords = {
    'ami':
        '${BengaliConstants.vowelAa}${BengaliConstants.conM}${BengaliConstants.karI}',
    'amra':
        '${BengaliConstants.vowelAa}${BengaliConstants.conM}${BengaliConstants.conR}${BengaliConstants.karAa}',
    'amader':
        '${BengaliConstants.vowelAa}${BengaliConstants.conM}${BengaliConstants.karAa}${BengaliConstants.conD}${BengaliConstants.karE}${BengaliConstants.conR}',
    'tumi':
        '${BengaliConstants.conT}${BengaliConstants.karU}${BengaliConstants.conM}${BengaliConstants.karI}',
    'tomra':
        '${BengaliConstants.conT}${BengaliConstants.karO}${BengaliConstants.conM}${BengaliConstants.conR}${BengaliConstants.karAa}',
    'tomader':
        '${BengaliConstants.conT}${BengaliConstants.karO}${BengaliConstants.conM}${BengaliConstants.karAa}${BengaliConstants.conD}${BengaliConstants.karE}${BengaliConstants.conR}',
    'tui':
        '${BengaliConstants.conT}${BengaliConstants.karU}${BengaliConstants.vowelI}',
    'apni':
        '${BengaliConstants.vowelAa}${BengaliConstants.conP}${BengaliConstants.conN}${BengaliConstants.karI}',
    'apnara':
        '${BengaliConstants.vowelAa}${BengaliConstants.conP}${BengaliConstants.conN}${BengaliConstants.karAa}${BengaliConstants.conR}${BengaliConstants.karAa}',
    'apnader':
        '${BengaliConstants.vowelAa}${BengaliConstants.conP}${BengaliConstants.conN}${BengaliConstants.karAa}${BengaliConstants.conD}${BengaliConstants.karE}${BengaliConstants.conR}',
    'she': '${BengaliConstants.conSh}${BengaliConstants.karE}',
    'tini':
        '${BengaliConstants.conT}${BengaliConstants.karI}${BengaliConstants.conN}${BengaliConstants.karI}',
    'dhaka':
        '${BengaliConstants.conDDh}${BengaliConstants.karAa}${BengaliConstants.conK}${BengaliConstants.karAa}',
    'bangladesh':
        '${BengaliConstants.conB}${BengaliConstants.karAa}${BengaliConstants.anusvara}${BengaliConstants.conL}${BengaliConstants.karAa}${BengaliConstants.conD}${BengaliConstants.karE}${BengaliConstants.conSh}',
    'bangladeshe':
        '${BengaliConstants.conB}${BengaliConstants.karAa}${BengaliConstants.anusvara}${BengaliConstants.conL}${BengaliConstants.karAa}${BengaliConstants.conD}${BengaliConstants.karE}${BengaliConstants.conSh}${BengaliConstants.karE}',
    'bangla':
        '${BengaliConstants.conB}${BengaliConstants.karAa}${BengaliConstants.anusvara}${BengaliConstants.conL}${BengaliConstants.karAa}',
    'banglay':
        '${BengaliConstants.conB}${BengaliConstants.karAa}${BengaliConstants.anusvara}${BengaliConstants.conL}${BengaliConstants.karAa}${BengaliConstants.conY}',
    'likhi':
        '${BengaliConstants.conL}${BengaliConstants.karI}${BengaliConstants.conKh}${BengaliConstants.karI}',
    'thaki':
        '${BengaliConstants.conTh}${BengaliConstants.karAa}${BengaliConstants.conK}${BengaliConstants.karI}',
    'bhalo':
        '${BengaliConstants.conBh}${BengaliConstants.karAa}${BengaliConstants.conL}${BengaliConstants.karO}',
    'valo':
        '${BengaliConstants.conBh}${BengaliConstants.karAa}${BengaliConstants.conL}${BengaliConstants.karO}',
    'kemon':
        '${BengaliConstants.conK}${BengaliConstants.karE}${BengaliConstants.conM}${BengaliConstants.conN}',
    'acho':
        '${BengaliConstants.vowelAa}${BengaliConstants.conChh}${BengaliConstants.karO}',
    'asen':
        '${BengaliConstants.vowelAa}${BengaliConstants.conChh}${BengaliConstants.karE}${BengaliConstants.conN}',
    'achen':
        '${BengaliConstants.vowelAa}${BengaliConstants.conChh}${BengaliConstants.karE}${BengaliConstants.conN}',
    'achhen':
        '${BengaliConstants.vowelAa}${BengaliConstants.conChh}${BengaliConstants.karE}${BengaliConstants.conN}',
    'achho':
        '${BengaliConstants.vowelAa}${BengaliConstants.conChh}${BengaliConstants.karO}',
    'ekhon':
        '${BengaliConstants.vowelE}${BengaliConstants.conKh}${BengaliConstants.conN}',
    'shob': '${BengaliConstants.conS}${BengaliConstants.conB}',
    'sob': '${BengaliConstants.conS}${BengaliConstants.conB}',
    'shonar':
        '${BengaliConstants.conS}${BengaliConstants.karO}${BengaliConstants.conN}${BengaliConstants.karAa}${BengaliConstants.conR}',
    'sonar':
        '${BengaliConstants.conS}${BengaliConstants.karO}${BengaliConstants.conN}${BengaliConstants.karAa}${BengaliConstants.conR}',
    'dhonnobad':
        '${BengaliConstants.conDh}${BengaliConstants.conN}${BengaliConstants.hasanta}${BengaliConstants.conZ}${BengaliConstants.conB}${BengaliConstants.karAa}${BengaliConstants.conD}',
    'shagotom':
        '${BengaliConstants.conS}${BengaliConstants.hasanta}${BengaliConstants.conB}${BengaliConstants.karAa}${BengaliConstants.conG}${BengaliConstants.conT}${BengaliConstants.conM}',
    'shundor':
        '${BengaliConstants.conS}${BengaliConstants.karU}${BengaliConstants.conN}${BengaliConstants.hasanta}${BengaliConstants.conD}${BengaliConstants.conR}',
    'sundor':
        '${BengaliConstants.conS}${BengaliConstants.karU}${BengaliConstants.conN}${BengaliConstants.hasanta}${BengaliConstants.conD}${BengaliConstants.conR}',
    'ki': '${BengaliConstants.conK}${BengaliConstants.karI}',
    'kintu':
        '${BengaliConstants.conK}${BengaliConstants.karI}${BengaliConstants.conN}${BengaliConstants.hasanta}${BengaliConstants.conT}${BengaliConstants.karU}',
    'ebong':
        '${BengaliConstants.vowelE}${BengaliConstants.conB}${BengaliConstants.anusvara}',
    'ar': '${BengaliConstants.vowelAa}${BengaliConstants.conR}',
    'aar': '${BengaliConstants.vowelAa}${BengaliConstants.conR}',
  };

  /// Independent vowels (at the start of a word or after another vowel).
  static const Map<String, String> independentVowels = {
    'rri': BengaliConstants.vowelRri,
    'aa': BengaliConstants.vowelAa,
    'ee': BengaliConstants.vowelEe,
    'oo': BengaliConstants.vowelOo,
    'oi': BengaliConstants.vowelOi,
    'ou': BengaliConstants.vowelOu,
    'ow': BengaliConstants.vowelOu,
    'a': BengaliConstants.vowelA,
    'A': BengaliConstants.vowelAa,
    'i': BengaliConstants.vowelI,
    'I': BengaliConstants.vowelEe,
    'u': BengaliConstants.vowelU,
    'U': BengaliConstants.vowelOo,
    'e': BengaliConstants.vowelE,
    'E': BengaliConstants.vowelE,
    'o': BengaliConstants.vowelO,
    'O': BengaliConstants.vowelO,
  };

  /// Dependent vowel signs (kar - placed after a consonant).
  static const Map<String, String> vowelSigns = {
    'rri': BengaliConstants.karRri,
    'aa': BengaliConstants.karAa,
    'ee': BengaliConstants.karEe,
    'oo': BengaliConstants.karOo,
    'oi': BengaliConstants.karOi,
    'ou': BengaliConstants.karOu,
    'ow': BengaliConstants.karOu,
    'a': BengaliConstants.karAa,
    'A': BengaliConstants.karAa,
    'i': BengaliConstants.karI,
    'I': BengaliConstants.karEe,
    'u': BengaliConstants.karU,
    'U': BengaliConstants.karOo,
    'e': BengaliConstants.karE,
    'o': BengaliConstants.karO,
    'O': '', // Inherent vowel without kar (kO -> Ka)
  };

  /// Multi-character and single-character consonant and conjunct mappings.
  /// Ordered so longer patterns match first.
  static const Map<String, String> consonants = {
    // 4-character conjuncts
    'kkhN':
        '${BengaliConstants.conK}${BengaliConstants.hasanta}${BengaliConstants.conSSh}${BengaliConstants.hasanta}${BengaliConstants.conNN}',
    'kkhm':
        '${BengaliConstants.conK}${BengaliConstants.hasanta}${BengaliConstants.conSSh}${BengaliConstants.hasanta}${BengaliConstants.conM}',
    'chchh':
        '${BengaliConstants.conCh}${BengaliConstants.hasanta}${BengaliConstants.conChh}',
    'shchh':
        '${BengaliConstants.conSh}${BengaliConstants.hasanta}${BengaliConstants.conChh}',
    'shth':
        '${BengaliConstants.conSSh}${BengaliConstants.hasanta}${BengaliConstants.conTTh}',

    // 3-character conjuncts & multi-letters
    'kkh':
        '${BengaliConstants.conK}${BengaliConstants.hasanta}${BengaliConstants.conSSh}',
    'gdh':
        '${BengaliConstants.conG}${BengaliConstants.hasanta}${BengaliConstants.conDh}',
    'ngkh':
        '${BengaliConstants.conNg}${BengaliConstants.hasanta}${BengaliConstants.conKh}',
    'nggh':
        '${BengaliConstants.conNg}${BengaliConstants.hasanta}${BengaliConstants.conGh}',
    'ngk':
        '${BengaliConstants.conNg}${BengaliConstants.hasanta}${BengaliConstants.conK}',
    'ngg':
        '${BengaliConstants.conNg}${BengaliConstants.hasanta}${BengaliConstants.conG}',
    'cch':
        '${BengaliConstants.conCh}${BengaliConstants.hasanta}${BengaliConstants.conChh}',
    'chh': BengaliConstants.conChh,
    'jjh':
        '${BengaliConstants.conJ}${BengaliConstants.hasanta}${BengaliConstants.conJh}',
    'jny':
        '${BengaliConstants.conJ}${BengaliConstants.hasanta}${BengaliConstants.conNy}',
    'TTh': BengaliConstants.conTTh,
    'DDh': BengaliConstants.conDDh,
    'tth':
        '${BengaliConstants.conT}${BengaliConstants.hasanta}${BengaliConstants.conTh}',
    'ddh':
        '${BengaliConstants.conD}${BengaliConstants.hasanta}${BengaliConstants.conDh}',
    'dbh':
        '${BengaliConstants.conD}${BengaliConstants.hasanta}${BengaliConstants.conBh}',
    'nth':
        '${BengaliConstants.conN}${BengaliConstants.hasanta}${BengaliConstants.conTh}',
    'ndh':
        '${BengaliConstants.conN}${BengaliConstants.hasanta}${BengaliConstants.conDh}',
    'bhr':
        '${BengaliConstants.conBh}${BengaliConstants.hasanta}${BengaliConstants.conR}',
    'mph':
        '${BengaliConstants.conM}${BengaliConstants.hasanta}${BengaliConstants.conPh}',
    'mbh':
        '${BengaliConstants.conM}${BengaliConstants.hasanta}${BengaliConstants.conBh}',
    'shN':
        '${BengaliConstants.conSSh}${BengaliConstants.hasanta}${BengaliConstants.conNN}',
    'shp':
        '${BengaliConstants.conSSh}${BengaliConstants.hasanta}${BengaliConstants.conP}',
    'sph':
        '${BengaliConstants.conS}${BengaliConstants.hasanta}${BengaliConstants.conPh}',
    'sth':
        '${BengaliConstants.conS}${BengaliConstants.hasanta}${BengaliConstants.conTh}',
    'shch':
        '${BengaliConstants.conSh}${BengaliConstants.hasanta}${BengaliConstants.conCh}',
    'sht':
        '${BengaliConstants.conSSh}${BengaliConstants.hasanta}${BengaliConstants.conTT}',

    // 2-character consonants & conjuncts
    'kh': BengaliConstants.conKh,
    'gh': BengaliConstants.conGh,
    'ng': BengaliConstants.anusvara, // Anusvara in Banglish words
    'Ng': BengaliConstants.conNg,
    'ch': BengaliConstants.conCh,
    'Ch': BengaliConstants.conChh,
    'jh': BengaliConstants.conJh,
    'ny': BengaliConstants.conNy,
    'Th': BengaliConstants.conTTh,
    'Dh': BengaliConstants.conDDh,
    'th': BengaliConstants.conTh,
    'dh': BengaliConstants.conDh,
    'ph': BengaliConstants.conPh,
    'bh': BengaliConstants.conBh,
    'sh': BengaliConstants.conSh,
    'Sh': BengaliConstants.conSSh,
    'Rh': BengaliConstants.conRrhh,

    // Common doubles
    'kk':
        '${BengaliConstants.conK}${BengaliConstants.hasanta}${BengaliConstants.conK}',
    'gg':
        '${BengaliConstants.conG}${BengaliConstants.hasanta}${BengaliConstants.conG}',
    'cc':
        '${BengaliConstants.conCh}${BengaliConstants.hasanta}${BengaliConstants.conCh}',
    'jj':
        '${BengaliConstants.conJ}${BengaliConstants.hasanta}${BengaliConstants.conJ}',
    'TT':
        '${BengaliConstants.conTT}${BengaliConstants.hasanta}${BengaliConstants.conTT}',
    'DD':
        '${BengaliConstants.conDD}${BengaliConstants.hasanta}${BengaliConstants.conDD}',
    'tt':
        '${BengaliConstants.conT}${BengaliConstants.hasanta}${BengaliConstants.conT}',
    'dd':
        '${BengaliConstants.conD}${BengaliConstants.hasanta}${BengaliConstants.conD}',
    'nn':
        '${BengaliConstants.conN}${BengaliConstants.hasanta}${BengaliConstants.conN}',
    'pp':
        '${BengaliConstants.conP}${BengaliConstants.hasanta}${BengaliConstants.conP}',
    'bb':
        '${BengaliConstants.conB}${BengaliConstants.hasanta}${BengaliConstants.conB}',
    'mm':
        '${BengaliConstants.conM}${BengaliConstants.hasanta}${BengaliConstants.conM}',
    'll':
        '${BengaliConstants.conL}${BengaliConstants.hasanta}${BengaliConstants.conL}',
    'ss':
        '${BengaliConstants.conS}${BengaliConstants.hasanta}${BengaliConstants.conS}',

    // Common consonant clusters
    'kt':
        '${BengaliConstants.conK}${BengaliConstants.hasanta}${BengaliConstants.conT}',
    'ks':
        '${BengaliConstants.conK}${BengaliConstants.hasanta}${BengaliConstants.conS}',
    'tm':
        '${BengaliConstants.conT}${BengaliConstants.hasanta}${BengaliConstants.conM}',
    'tr':
        '${BengaliConstants.conT}${BengaliConstants.hasanta}${BengaliConstants.conR}',
    'dm':
        '${BengaliConstants.conD}${BengaliConstants.hasanta}${BengaliConstants.conM}',
    'db':
        '${BengaliConstants.conD}${BengaliConstants.hasanta}${BengaliConstants.conB}',
    'nt':
        '${BengaliConstants.conN}${BengaliConstants.hasanta}${BengaliConstants.conT}',
    'nd':
        '${BengaliConstants.conN}${BengaliConstants.hasanta}${BengaliConstants.conD}',
    'pl':
        '${BengaliConstants.conP}${BengaliConstants.hasanta}${BengaliConstants.conL}',
    'bd':
        '${BengaliConstants.conB}${BengaliConstants.hasanta}${BengaliConstants.conD}',
    'bl':
        '${BengaliConstants.conB}${BengaliConstants.hasanta}${BengaliConstants.conL}',
    'mn':
        '${BengaliConstants.conM}${BengaliConstants.hasanta}${BengaliConstants.conN}',
    'mp':
        '${BengaliConstants.conM}${BengaliConstants.hasanta}${BengaliConstants.conP}',
    'mb':
        '${BengaliConstants.conM}${BengaliConstants.hasanta}${BengaliConstants.conB}',
    'st':
        '${BengaliConstants.conS}${BengaliConstants.hasanta}${BengaliConstants.conT}',
    'sn':
        '${BengaliConstants.conS}${BengaliConstants.hasanta}${BengaliConstants.conN}',
    'sp':
        '${BengaliConstants.conS}${BengaliConstants.hasanta}${BengaliConstants.conP}',
    'sm':
        '${BengaliConstants.conS}${BengaliConstants.hasanta}${BengaliConstants.conM}',
    'sl':
        '${BengaliConstants.conS}${BengaliConstants.hasanta}${BengaliConstants.conL}',
    'sk':
        '${BengaliConstants.conS}${BengaliConstants.hasanta}${BengaliConstants.conK}',

    // Modifiers & special notations
    't`': BengaliConstants.khandaTa,
    'ng`': BengaliConstants.conNg,
    '::': BengaliConstants.visarga,
    ':`': BengaliConstants.visarga,
    '^': BengaliConstants.candrabindu,
    ',,': BengaliConstants.hasanta,
    '``': BengaliConstants.hasanta,
    '..': BengaliConstants.danda,

    // Single-character consonants
    'k': BengaliConstants.conK,
    'g': BengaliConstants.conG,
    'c': BengaliConstants.conCh,
    'j': BengaliConstants.conJ,
    'J': BengaliConstants.conJh,
    'T': BengaliConstants.conTT,
    'D': BengaliConstants.conDD,
    'N': BengaliConstants.conNN,
    't': BengaliConstants.conT,
    'd': BengaliConstants.conD,
    'n': BengaliConstants.conN,
    'p': BengaliConstants.conP,
    'f': BengaliConstants.conPh,
    'b': BengaliConstants.conB,
    'v': BengaliConstants.conBh,
    'm': BengaliConstants.conM,
    'z': BengaliConstants.conZ,
    'r': BengaliConstants.conR,
    'l': BengaliConstants.conL,
    'S': BengaliConstants.conSh,
    's': BengaliConstants.conS,
    'h': BengaliConstants.conH,
    'H': BengaliConstants.visarga,
    'R': BengaliConstants.conRrh,
    'y': BengaliConstants.conY,
    'w': BengaliConstants.vowelO,
  };
}

// ignore_for_file: constant_identifier_names

import 'dart:ui' as widgets show Locale;

import 'package:flutter/widgets.dart' show BuildContext, Localizations;

enum Locale {
  /// Any language
  any('*'),

  /// Afar
  aa('aa'),

  /// Abkhazian
  ab('ab'),

  /// Avestan
  ae('ae'),

  /// Afrikaans
  af('af'),

  /// Akan
  ak('ak'),

  /// Amharic
  am('am'),

  /// Aragonese
  an('an'),

  /// Arabic (U.A.E.)
  ar_ae('ar', 'ae'),

  /// Arabic (Bahrain)
  ar_bh('ar', 'bh'),

  /// Arabic (Algeria)
  ar_dz('ar', 'dz'),

  /// Arabic (Egypt)
  ar_eg('ar', 'eg'),

  /// Arabic (Iraq)
  ar_iq('ar', 'iq'),

  /// Arabic (Jordan)
  ar_jo('ar', 'jo'),

  /// Arabic (Kuwait)
  ar_kw('ar', 'kw'),

  /// Arabic (Lebanon)
  ar_lb('ar', 'lb'),

  /// Arabic (Libya)
  ar_ly('ar', 'ly'),

  /// Arabic (Morocco)
  ar_ma('ar', 'ma'),

  /// Arabic (Oman)
  ar_om('ar', 'om'),

  /// Arabic (Qatar)
  ar_qa('ar', 'qa'),

  /// Arabic (Saudi Arabia)
  ar_sa('ar', 'sa'),

  /// Arabic (Syria)
  ar_sy('ar', 'sy'),

  /// Arabic (Tunisia)
  ar_tn('ar', 'tn'),

  /// Arabic (Yemen)
  ar_ye('ar', 'ye'),

  /// Arabic
  ar('ar'),

  /// Assamese
  as('as'),

  /// Avaric
  av('av'),

  /// Aymara
  ay('ay'),

  /// Azeri
  az('az'),

  /// Bashkir
  ba('ba'),

  /// Belarusian
  be('be'),

  /// Bulgarian
  bg('bg'),

  /// Bihari
  bh('bh'),

  /// Bislama
  bi('bi'),

  /// Bambara
  bm('bm'),

  /// Bengali
  bn('bn'),

  /// Tibetan
  bo('bo'),

  /// Breton
  br('br'),

  /// Bosnian
  bs('bs'),

  /// Catalan
  ca('ca'),

  /// Chechen
  ce('ce'),

  /// Chamorro
  ch('ch'),

  /// Corsican
  co('co'),

  /// Cree
  cr('cr'),

  /// Czech
  cs('cs'),

  /// Church Slavonic
  cu('cu'),

  /// Chuvash
  cv('cv'),

  /// Welsh
  cy('cy'),

  /// Danish
  da('da'),

  /// German (Austria)
  de_at('de', 'at'),

  /// German (Switzerland)
  de_ch('de', 'ch'),

  /// German (Germany)
  de_de('de', 'de'),

  /// German (Liechtenstein)
  de_li('de', 'li'),

  /// German (Luxembourg)
  de_lu('de', 'lu'),

  /// German
  de('de'),

  /// Divehi
  div('div'),

  /// Divehi
  dv('dv'),

  /// Bhutani
  dz('dz'),

  /// Ewe
  ee('ee'),

  /// Greek
  el('el'),

  /// English (Australia)
  en_au('en', 'au'),

  /// English (Belize)
  en_bz('en', 'bz'),

  /// English (Canada)
  en_ca('en', 'ca'),

  /// English (Caribbean)
  en_cb('en', 'cb'),

  /// English (United Kingdom)
  en_gb('en', 'gb'),

  /// English (Ireland)
  en_ie('en', 'ie'),

  /// English (Jamaica)
  en_jm('en', 'jm'),

  /// English (New Zealand)
  en_nz('en', 'nz'),

  /// English (Philippines)
  en_ph('en', 'ph'),

  /// English (Trinidad and Tobago)
  en_tt('en', 'tt'),

  /// English (United States)
  en_us('en', 'us'),

  /// English (South Africa)
  en_za('en', 'za'),

  /// English (Zimbabwe)
  en_zw('en', 'zw'),

  /// English
  en('en'),

  /// Esperanto
  eo('eo'),

  /// Spanish (Argentina)
  es_ar('es', 'ar'),

  /// Spanish (Bolivia)
  es_bo('es', 'bo'),

  /// Spanish (Chile)
  es_cl('es', 'cl'),

  /// Spanish (Colombia)
  es_co('es', 'co'),

  /// Spanish (Costa Rica)
  es_cr('es', 'cr'),

  /// Spanish (Dominican Republic)
  es_do('es', 'do'),

  /// Spanish (Ecuador)
  es_ec('es', 'ec'),

  /// Spanish (Spain)
  es_es('es', 'es'),

  /// Spanish (Guatemala)
  es_gt('es', 'gt'),

  /// Spanish (Honduras)
  es_hn('es', 'hn'),

  /// Spanish (Mexico)
  es_mx('es', 'mx'),

  /// Spanish (Nicaragua)
  es_ni('es', 'ni'),

  /// Spanish (Panama)
  es_pa('es', 'pa'),

  /// Spanish (Peru)
  es_pe('es', 'pe'),

  /// Spanish (Puerto Rico)
  es_pr('es', 'pr'),

  /// Spanish (Paraguay)
  es_py('es', 'py'),

  /// Spanish (El Salvador)
  es_sv('es', 'sv'),

  /// Spanish (United States)
  es_us('es', 'us'),

  /// Spanish (Uruguay)
  es_uy('es', 'uy'),

  /// Spanish (Venezuela)
  es_ve('es', 've'),

  /// Spanish
  es('es'),

  /// Estonian
  et('et'),

  /// Basque
  eu('eu'),

  /// Farsi
  fa('fa'),

  /// Fulah
  ff('ff'),

  /// Finnish
  fi('fi'),

  /// Fiji
  fj('fj'),

  /// Faroese
  fo('fo'),

  /// French (Belgium)
  fr_be('fr', 'be'),

  /// French (Canada)
  fr_ca('fr', 'ca'),

  /// French (Switzerland)
  fr_ch('fr', 'ch'),

  /// French (France)
  fr_fr('fr', 'fr'),

  /// French (Luxembourg)
  fr_lu('fr', 'lu'),

  /// French (Monaco)
  fr_mc('fr', 'mc'),

  /// French
  fr('fr'),

  /// Frisian
  fy('fy'),

  /// Irish
  ga('ga'),

  /// Gaelic
  gd('gd'),

  /// Galician
  gl('gl'),

  /// Guarani
  gn('gn'),

  /// Gujarati
  gu('gu'),

  /// Manx
  gv('gv'),

  /// Hausa
  ha('ha'),

  /// Hebrew
  he('he'),

  /// Hindi
  hi('hi'),

  /// Hiri Motu
  ho('ho'),

  /// Croatian (Bosnia and Herzegovina)
  hr_ba('hr', 'ba'),

  /// Croatian (Croatia)
  hr_hr('hr', 'hr'),

  /// Croatian
  hr('hr'),

  /// Haitian
  ht('ht'),

  /// Hungarian
  hu('hu'),

  /// Armenian
  hy('hy'),

  /// Herero
  hz('hz'),

  /// Interlingua
  ia('ia'),

  /// Indonesian
  id('id'),

  /// Interlingue
  ie('ie'),

  /// Igbo
  ig('ig'),

  /// Sichuan Yi
  ii('ii'),

  /// Inupiak
  ik('ik'),

  /// Indonesian
  in_in('in'),

  /// Ido
  io('io'),

  /// Icelandic
  is_is('is'),

  /// Italian (Switzerland)
  it_ch('it', 'ch'),

  /// Italian (Italy)
  it_it('it', 'it'),

  /// Italian
  it('it'),

  /// Inuktitut
  iu('iu'),

  /// Hebrew
  iw('iw'),

  /// Japanese
  ja('ja'),

  /// Yiddish
  ji('ji'),

  /// Javanese
  jv('jv'),

  /// Javanese
  jw('jw'),

  /// Georgian
  ka('ka'),

  /// Kongo
  kg('kg'),

  /// Kikuyu
  ki('ki'),

  /// Kuanyama
  kj('kj'),

  /// Kazakh
  kk('kk'),

  /// Greenlandic
  kl('kl'),

  /// Cambodian
  km('km'),

  /// Kannada
  kn('kn'),

  /// Korean
  ko('ko'),

  /// Konkani
  kok('kok'),

  /// Kanuri
  kr('kr'),

  /// Kashmiri
  ks('ks'),

  /// Kurdish
  ku('ku'),

  /// Komi
  kv('kv'),

  /// Cornish
  kw('kw'),

  /// Kirghiz
  ky('ky'),

  /// Kyrgyz
  kz('kz'),

  /// Latin
  la('la'),

  /// Luxembourgish
  lb('lb'),

  /// Ganda
  lg('lg'),

  /// Limburgan
  li('li'),

  /// Lingala
  ln('ln'),

  /// Laothian
  lo('lo'),

  /// Slovenian
  ls('ls'),

  /// Lithuanian
  lt('lt'),

  /// Luba-Katanga
  lu('lu'),

  /// Latvian
  lv('lv'),

  /// Malagasy
  mg('mg'),

  /// Marshallese
  mh('mh'),

  /// Maori
  mi('mi'),

  /// FYRO Macedonian
  mk('mk'),

  /// Malayalam
  ml('ml'),

  /// Mongolian
  mn('mn'),

  /// Moldavian
  mo('mo'),

  /// Marathi
  mr('mr'),

  /// Malay (Brunei Darussalam)
  ms_bn('ms', 'bn'),

  /// Malay (Malaysia)
  ms_my('ms', 'my'),

  /// Malay
  ms('ms'),

  /// Maltese
  mt('mt'),

  /// Burmese
  my('my'),

  /// Nauru
  na('na'),

  /// Norwegian (Bokmal)
  nb('nb'),

  /// North Ndebele
  nd('nd'),

  /// Nepali (India)
  ne('ne'),

  /// Ndonga
  ng('ng'),

  /// Dutch (Belgium)
  nl_be('nl', 'be'),

  /// Dutch (Netherlands)
  nl_nl('nl', 'nl'),

  /// Dutch
  nl('nl'),

  /// Norwegian (Nynorsk)
  nn('nn'),

  /// Norwegian
  no('no'),

  /// South Ndebele
  nr('nr'),

  /// Northern Sotho
  ns('ns'),

  /// Navajo
  nv('nv'),

  /// Chichewa
  ny('ny'),

  /// Occitan
  oc('oc'),

  /// Ojibwa
  oj('oj'),

  /// (Afan)/Oromoor/Oriya
  om('om'),

  /// Oriya
  or('or'),

  /// Ossetian
  os('os'),

  /// Punjabi
  pa('pa'),

  /// Pali
  pi('pi'),

  /// Polish
  pl('pl'),

  /// Pashto/Pushto
  ps('ps'),

  /// Portuguese (Brazil)
  pt_br('pt', 'br'),

  /// Portuguese (Portugal)
  pt_pt('pt', 'pt'),

  /// Portuguese
  pt('pt'),

  /// Quechua (Bolivia)
  qu_bo('qu', 'bo'),

  /// Quechua (Ecuador)
  qu_ec('qu', 'ec'),

  /// Quechua (Peru)
  qu_pe('qu', 'pe'),

  /// Quechua
  qu('qu'),

  /// Rhaeto-Romanic
  rm('rm'),

  /// Kirundi
  rn('rn'),

  /// Romanian
  ro('ro'),

  /// Russian
  ru('ru'),

  /// Kinyarwanda
  rw('rw'),

  /// Sanskrit
  sa('sa'),

  /// Sorbian
  sb('sb'),

  /// Sardinian
  sc('sc'),

  /// Sindhi
  sd('sd'),

  /// Sami (Finland)
  se_fi('se', 'fi'),

  /// Sami (Norway)
  se_no('se', 'no'),

  /// Sami (Sweden)
  se_se('se', 'se'),

  /// Sami
  se('se'),

  /// Sangro
  sg('sg'),

  /// Serbo-Croatian
  sh('sh'),

  /// Singhalese
  si('si'),

  /// Slovak
  sk('sk'),

  /// Slovenian
  sl('sl'),

  /// Samoan
  sm('sm'),

  /// Shona
  sn('sn'),

  /// Somali
  so('so'),

  /// Albanian
  sq('sq'),

  /// Serbian (Bosnia and Herzegovina)
  sr_ba('sr', 'ba'),

  /// Serbian (Serbia and Montenegro)
  sr_sp('sr', 'sp'),

  /// Serbian
  sr('sr'),

  /// Siswati
  ss('ss'),

  /// Sesotho
  st('st'),

  /// Sundanese
  su('su'),

  /// Swedish (Finland)
  sv_fi('sv', 'fi'),

  /// Swedish (Sweden)
  sv_se('sv', 'se'),

  /// Swedish
  sv('sv'),

  /// Swahili
  sw('sw'),

  /// Sutu
  sx('sx'),

  /// Syriac
  syr('syr'),

  /// Tamil
  ta('ta'),

  /// Telugu
  te('te'),

  /// Tajik
  tg('tg'),

  /// Thai
  th('th'),

  /// Tigrinya
  ti('ti'),

  /// Turkmen
  tk('tk'),

  /// Tagalog
  tl('tl'),

  /// Tswana
  tn('tn'),

  /// Tonga
  to('to'),

  /// Turkish
  tr('tr'),

  /// Tsonga
  ts('ts'),

  /// Tatar
  tt('tt'),

  /// Twi
  tw('tw'),

  /// Tahitian
  ty('ty'),

  /// Uighur
  ug('ug'),

  /// Ukrainian
  uk('uk'),

  /// Urdu
  ur('ur'),

  /// English
  us('us'),

  /// Uzbek
  uz('uz'),

  /// Venda
  ve('ve'),

  /// Vietnamese
  vi('vi'),

  /// Volapuk
  vo('vo'),

  /// Walloon
  wa('wa'),

  /// Wolof
  wo('wo'),

  /// Xhosa
  xh('xh'),

  /// Yiddish
  yi('yi'),

  /// Yoruba
  yo('yo'),

  /// Zhuang
  za('za'),

  /// Chinese (China)
  zh_cn('zh', 'cn'),

  /// Chinese (Hong Kong SAR)
  zh_hk('zh', 'hk'),

  /// Chinese (Macau SAR)
  zh_mo('zh', 'mo'),

  /// Chinese (Singapore)
  zh_sg('zh', 'sg'),

  /// Chinese (Taiwan)
  zh_tw('zh', 'tw'),

  /// Chinese
  zh('zh'),

  /// Zulu
  zu('zu');

  final String languageCode;
  final String? countryCode;

  const Locale(this.languageCode, [this.countryCode]);

  widgets.Locale get flutterLocale {
    return countryCode == null
        ? widgets.Locale(languageCode)
        : widgets.Locale(languageCode, countryCode);
  }

  static Locale fromFlutterLocale(widgets.Locale uiLocale) {
    // Try exact match first (language + country)
    final exactMatch = Locale.values.firstWhere(
      (locale) =>
          locale.languageCode.toLowerCase() ==
              uiLocale.languageCode.toLowerCase() &&
          (locale.countryCode?.toLowerCase() ?? '') ==
              (uiLocale.countryCode?.toLowerCase() ?? ''),
      orElse: () => Locale.en,
    );

    if (exactMatch != Locale.en) {
      return exactMatch;
    }

    // Try language-only match
    final languageMatch = Locale.values.firstWhere(
      (locale) =>
          locale.languageCode.toLowerCase() ==
          uiLocale.languageCode.toLowerCase(),
      orElse: () => Locale.en,
    );

    return languageMatch;
  }

  @override
  String toString() {
    return countryCode == null ? languageCode : '${languageCode}_$countryCode';
  }
}

typedef Locales = List<Locale>;

extension LocaleExtension on BuildContext {
  /// Returns the current locale of the application.
  ///
  /// This method retrieves the current locale from the `AppContext` and returns it.
  Locale get currentLocale {
    final current = Localizations.localeOf(this);
    return Locale.fromFlutterLocale(current);
  }
}

-- DROP DATABASE IF EXISTS oxatrade;

-- oxatrade.organizations definition
CREATE TABLE IF NOT EXISTS oxatrade.organizations (
  id bigint unsigned NOT NULL AUTO_INCREMENT, -- customer ID > 10000
  org_name varchar(64) NOT NULL COMMENT 'title of organisation',
  email varchar(64) DEFAULT NULL,
  phone varchar(25) DEFAULT NULL,
  enabled BOOLEAN NOT NULL DEFAULT '1' COMMENT 'If is active',
  created_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  memo text COMMENT 'memo/information',
  PRIMARY KEY (id)
) ENGINE=InnoDB AUTO_INCREMENT=10000 CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Organizations and firms';

-- oxatrade.users_organizations definition
-- Many-to-many connection
CREATE TABLE IF NOT EXISTS oxatrade.users_organizations (
  user_id BINARY(16) NOT NULL,
  org_id bigint unsigned NOT NULL,
  user_org_role varchar(32) DEFAULT NULL,
  PRIMARY KEY (user_id, org_id),
  KEY `FKh8ciramu9cc9q3qcqiv4ue8a6` (org_id),
  CONSTRAINT `FKh8ciramu9cc9q3qcqiv4ue8a6` FOREIGN KEY (org_id) REFERENCES oxatrade.organizations (id) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT `FKhfh9dx7w3ubf1co1vdev94g3f` FOREIGN KEY (user_id) REFERENCES oxatrade.users (id) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Many-to-many between users and organizations';

-- oxatrade.countries definition
CREATE TABLE IF NOT EXISTS oxatrade.countries (
  country_code char(2) NOT NULL COMMENT 'Country abbreviation',
  country_name varchar(200) DEFAULT NULL COMMENT 'Country name',
  phone_prefix varchar(10) DEFAULT NULL COMMENT 'Telephone prefix',
  enabled BOOLEAN NOT NULL DEFAULT '1' COMMENT 'If is active',
  PRIMARY KEY (country_code)
) ENGINE=InnoDB CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Countries and Nations';

-- oxatrade.addresses definition
CREATE TABLE IF NOT EXISTS oxatrade.addresses (
  id BINARY(16) NOT NULL,
  org_id bigint unsigned DEFAULT NULL COMMENT 'id of organisation if not from user',
  title_name varchar(64) DEFAULT NULL COMMENT 'users name / firma / org',
  alias_name varchar(64) DEFAULT NULL COMMENT 'additional address name',
  street_name varchar(70) DEFAULT NULL,
  house_number varchar(9) DEFAULT NULL,
  district_name varchar(200) DEFAULT NULL COMMENT 'Part of a city/Additional data',
  city_name varchar(200) NOT NULL COMMENT 'City name',
  zip_code varchar(9) NOT NULL COMMENT 'Postal code',
  state_name varchar(75) DEFAULT NULL COMMENT 'Complete state name',
  country_code char(2) NOT NULL COMMENT 'Country identification',
  email varchar(64) DEFAULT NULL,
  phone varchar(25) DEFAULT NULL,
  created_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  memo text COMMENT 'memo/information',
  PRIMARY KEY (id),
  KEY country_code (country_code),
  KEY addresses_FK (org_id),
  CONSTRAINT addresses_FK FOREIGN KEY (org_id) REFERENCES oxatrade.organizations (id) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT addresses_ibfk_1 FOREIGN KEY (country_code) REFERENCES oxatrade.countries (country_code) ON UPDATE CASCADE
) ENGINE=InnoDB CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Addresses for users, customers, organizations...';

-- Triggers to automatically generate the UUID by "users"
 CREATE TRIGGER IF NOT EXISTS before_insert_addresses
 BEFORE INSERT ON oxatrade.addresses
 FOR EACH ROW
 BEGIN
     IF NEW.id IS NULL THEN
         SET NEW.id = (UUID_TO_BIN(UUID()));
     END IF;
 END;

-- Dumping data for table "oxatrade.countries"
INSERT INTO oxatrade.countries (country_code, country_name, phone_prefix) VALUES
('AF', 'Afghanistan', '+93'),
('AL', 'Albania', '+355'),
('DZ', 'Algeria', '+213'),
('AS', 'American Samoa', '+1-684'),
('AD', 'Andorra', '+376'),
('AO', 'Angola', '+244'),
('AI', 'Anguilla', '+1-264'),
('AQ', 'Antarctica', null),
('AG', 'Antigua and Barbuda', '+1-268'),
('AR', 'Argentina', '+54'),
('AM', 'Armenia', '+374'),
('AW', 'Aruba', '+297'),
('AU', 'Australia', '+61'),
('AT', 'Austria', '+43'),
('AZ', 'Azerbaijan', '+994'),
('BS', 'Bahamas', '+1-242'),
('BH', 'Bahrain', '+973'),
('BD', 'Bangladesh', '+880'),
('BB', 'Barbados', '+1-246'),
('BY', 'Belarus', '+375'),
('BE', 'Belgium', '+32'),
('BZ', 'Belize', '+501'),
('BJ', 'Benin', '+229'),
('BM', 'Bermuda', '+1-441'),
('BT', 'Bhutan', '+975'),
('BO', 'Bolivia', '+591'),
('BA', 'Bosnia and Herzegovina', '+387'),
('BW', 'Botswana', '+267'),
('BV', 'Bouvet Island', null),
('BR', 'Brazil', '+55'),
('IO', 'British Indian Ocean Territory', '+246'),
('BN', 'Brunei Darussalam', '+673'),
('BG', 'Bulgaria', '+359'),
('BF', 'Burkina Faso', '+226'),
('BI', 'Burundi', '+257'),
('KH', 'Cambodia', '+855'),
('CM', 'Cameroon', '+237'),
('CA', 'Canada', '+1'),
('CV', 'Cape Verde', '+238'),
('KY', 'Cayman Islands', '+1-345'),
('CF', 'Central African Republic', '+236'),
('TD', 'Chad', '+235'),
('CL', 'Chile', '+56'),
('CN', 'China', '+86'),
('CX', 'Christmas Island', '+61'),
('CC', 'Cocos (Keeling) Islands', '+61'),
('CO', 'Colombia', '+57'),
('KM', 'Comoros', '+269'),
('CD', 'Democratic Republic of the Congo', '+243'),
('CG', 'Republic of the Congo', '+242'),
('CK', 'Cook Islands', '+682'),
('CR', 'Costa Rica', '+506'),
('HR', 'Croatia (Hrvatska)', '+385'),
('CU', 'Cuba', '+53'),
('CY', 'Cyprus', '+357'),
('CZ', 'Czech Republic', '+420'),
('DK', 'Denmark', '+45'),
('DJ', 'Djibouti', '+253'),
('DM', 'Dominica', '+1-767'),
('DO', 'Dominican Republic', '+1-809'),
('TL', 'East Timor', '+670'),
('EC', 'Ecuador', '+593'),
('EG', 'Egypt', '+20'),
('SV', 'El Salvador', '+503'),
('GQ', 'Equatorial Guinea', '+240'),
('ER', 'Eritrea', '+291'),
('EE', 'Estonia', '+372'),
('ET', 'Ethiopia', '+251'),
('FK', 'Falkland Islands (Malvinas)', '+500'),
('FO', 'Faroe Islands', '+298'),
('FJ', 'Fiji', '+679'),
('FI', 'Finland', '+358'),
('FR', 'France', '+33'),
('FX', 'France, Metropolitan', '+33'),
('GF', 'French Guiana', '+594'),
('PF', 'French Polynesia', '+689'),
('TF', 'French Southern Territories', null),
('GA', 'Gabon', '+241'),
('GM', 'Gambia', '+220'),
('GE', 'Georgia', '+995'),
('DE', 'Germany', '+49'),
('GH', 'Ghana', '+233'),
('GI', 'Gibraltar', '+350'),
('GG', 'Guernsey', '+44'),
('GR', 'Greece', '+30'),
('GL', 'Greenland', '+299'),
('GD', 'Grenada', '+1-473'),
('GP', 'Guadeloupe', '+590'),
('GU', 'Guam', '+1-671'),
('GT', 'Guatemala', '+502'),
('GN', 'Guinea', '+224'),
('GW', 'Guinea-Bissau', '+245'),
('GY', 'Guyana', '+592'),
('HT', 'Haiti', '+509'),
('HM', 'Heard and Mc Donald Islands', null),
('HN', 'Honduras', '+504'),
('HK', 'Hong Kong', '+852'),
('HU', 'Hungary', '+36'),
('IS', 'Iceland', '+354'),
('IN', 'India', '+91'),
('IM', 'Isle of Man', '+44'),
('ID', 'Indonesia', '+62'),
('IR', 'Iran (Islamic Republic of)', '+98'),
('IQ', 'Iraq', '+964'),
('IE', 'Ireland', '+353'),
('IL', 'Israel', '+972'),
('IT', 'Italy', '+39'),
('CI', 'Ivory Coast', '+225'),
('JE', 'Jersey', '+44'),
('JM', 'Jamaica', '+1-876'),
('JP', 'Japan', '+81'),
('JO', 'Jordan', '+962'),
('KZ', 'Kazakhstan', '+7'),
('KE', 'Kenya', '+254'),
('KI', 'Kiribati', '+686'),
('KP', 'Korea, Democratic People''s Republic of', '+850'),
('KR', 'Korea, Republic of', '+82'),
('XK', 'Kosovo', null),
('KW', 'Kuwait', '+965'),
('KG', 'Kyrgyzstan', '+996'),
('LA', 'Lao People''s Democratic Republic', '+856'),
('LV', 'Latvia', '+371'),
('LB', 'Lebanon', '+961'),
('LS', 'Lesotho', '+266'),
('LR', 'Liberia', '+231'),
('LY', 'Libyan Arab Jamahiriya', '+218'),
('LI', 'Liechtenstein', '+423'),
('LT', 'Lithuania', '+370'),
('LU', 'Luxembourg', '+352'),
('MO', 'Macau', '+853'),
('MK', 'North Macedonia', '+389'),
('MG', 'Madagascar', '+261'),
('MW', 'Malawi', '+265'),
('MY', 'Malaysia', '+60'),
('MV', 'Maldives', '+960'),
('ML', 'Mali', '+223'),
('MT', 'Malta', '+356'),
('MH', 'Marshall Islands', '+692'),
('MQ', 'Martinique', '+596'),
('MR', 'Mauritania', '+222'),
('MU', 'Mauritius', '+230'),
('YT', 'Mayotte', '+262'),
('MX', 'Mexico', '+52'),
('FM', 'Micronesia, Federated States of', '+691'),
('MD', 'Moldova, Republic of', '+373'),
('MC', 'Monaco', '+377'),
('MN', 'Mongolia', '+976'),
('ME', 'Montenegro', '+382'),
('MS', 'Montserrat', '+1-664'),
('MA', 'Morocco', '+212'),
('MZ', 'Mozambique', '+258'),
('MM', 'Myanmar', '+95'),
('NA', 'Namibia', '+264'),
('NR', 'Nauru', '+674'),
('NP', 'Nepal', '+977'),
('NL', 'Netherlands', '+31'),
('AN', 'Netherlands Antilles', '+599'),
('NC', 'New Caledonia', '+687'),
('NZ', 'New Zealand', '+64'),
('NI', 'Nicaragua', '+505'),
('NE', 'Niger', '+227'),
('NG', 'Nigeria', '+234'),
('NU', 'Niue', '+683'),
('NF', 'Norfolk Island', null),
('MP', 'Northern Mariana Islands', '+1-670'),
('NO', 'Norway', '+47'),
('OM', 'Oman', '+968'),
('PK', 'Pakistan', '+92'),
('PW', 'Palau', '+680'),
('PS', 'Palestine', '+970'),
('PA', 'Panama', '+507'),
('PG', 'Papua New Guinea', '+675'),
('PY', 'Paraguay', '+595'),
('PE', 'Peru', '+51'),
('PH', 'Philippines', '+63'),
('PN', 'Pitcairn', null),
('PL', 'Poland', '+48'),
('PT', 'Portugal', '+351'),
('PR', 'Puerto Rico', '+1-787'),
('QA', 'Qatar', '+974'),
('RE', 'Reunion', '+262'),
('RO', 'Romania', '+40'),
('RU', 'Russian Federation', '+7'),
('RW', 'Rwanda', '+250'),
('KN', 'Saint Kitts and Nevis', '+1-869'),
('LC', 'Saint Lucia', '+1-758'),
('VC', 'Saint Vincent and the Grenadines', '+1-784'),
('WS', 'Samoa', '+685'),
('SM', 'San Marino', '+378'),
('ST', 'Sao Tome and Principe', '+239'),
('SA', 'Saudi Arabia', '+966'),
('SN', 'Senegal', '+221'),
('RS', 'Serbia', '+381'),
('SC', 'Seychelles', '+248'),
('SL', 'Sierra Leone', '+232'),
('SG', 'Singapore', '+65'),
('SK', 'Slovakia', '+421'),
('SI', 'Slovenia', '+386'),
('SB', 'Solomon Islands', '+677'),
('SO', 'Somalia', '+252'),
('ZA', 'South Africa', '+27'),
('GS', 'South Georgia South Sandwich Islands', null),
('SS', 'South Sudan', '+211'),
('ES', 'Spain', '+34'),
('LK', 'Sri Lanka', '+94'),
('SH', 'St. Helena', '+290'),
('PM', 'St. Pierre and Miquelon', '+508'),
('SD', 'Sudan', '+249'),
('SR', 'Suriname', '+597'),
('SJ', 'Svalbard and Jan Mayen Islands', null),
('SZ', 'Eswatini', '+268'),
('SE', 'Sweden', '+46'),
('CH', 'Switzerland', '+41'),
('SY', 'Syrian Arab Republic', '+963'),
('TW', 'Taiwan', '+886'),
('TJ', 'Tajikistan', '+992'),
('TZ', 'Tanzania, United Republic of', '+255'),
('TH', 'Thailand', '+66'),
('TG', 'Togo', '+228'),
('TK', 'Tokelau', '+690'),
('TO', 'Tonga', '+676'),
('TT', 'Trinidad and Tobago', '+1-868'),
('TN', 'Tunisia', '+216'),
('TR', 'Turkey', '+90'),
('TM', 'Turkmenistan', '+993'),
('TC', 'Turks and Caicos Islands', '+1-649'),
('TV', 'Tuvalu', '+688'),
('UG', 'Uganda', '+256'),
('UA', 'Ukraine', '+380'),
('AE', 'United Arab Emirates', '+971'),
('GB', 'United Kingdom', '+44'),
('US', 'United States', '+1'),
('UM', 'United States minor outlying islands', null),
('UY', 'Uruguay', '+598'),
('UZ', 'Uzbekistan', '+998'),
('VU', 'Vanuatu', '+678'),
('VA', 'Vatican City State', '+379'),
('VE', 'Venezuela', '+58'),
('VN', 'Vietnam', '+84'),
('VG', 'Virgin Islands (British)', '+1-284'),
('VI', 'Virgin Islands (U.S.)', '+1-340'),
('WF', 'Wallis and Futuna Islands', '+681'),
('EH', 'Western Sahara', null),
('YE', 'Yemen', '+967'),
('ZM', 'Zambia', '+260'),
('ZW', 'Zimbabwe', '+263');

CREATE TABLE angel_number_catalog (
  amount INTEGER PRIMARY KEY,
  angel_number TEXT NOT NULL UNIQUE,
  meaning TEXT NOT NULL,
  created_at TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE app_events (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  event_type TEXT NOT NULL,
  actor_user_id INTEGER,
  payload_json TEXT,
  created_at TEXT NOT NULL DEFAULT (datetime('now')),
  FOREIGN KEY (actor_user_id) REFERENCES users(id) ON DELETE SET NULL
);

CREATE TABLE app_settings (
  id INTEGER PRIMARY KEY,
  setting_key TEXT UNIQUE,
  setting_value TEXT,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE bible_verses (
  id INTEGER PRIMARY KEY,
  verse_reference TEXT NOT NULL,
  verse_text_nl TEXT NOT NULL,
  verse_text_en TEXT NOT NULL,
  theme TEXT NOT NULL CHECK(theme IN ('troost','kracht','geduld','liefde','vergeving','hoop','vrede','dankbaarheid')),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE blessings (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  from_user_id INTEGER,
  to_user_id INTEGER,
  from_email TEXT,
  to_email TEXT,
  message TEXT NOT NULL,
  blessing_type TEXT NOT NULL CHECK (blessing_type IN ('bericht','gedicht','tekening','boodschap')),
  related_gift_id INTEGER,
  created_at TEXT NOT NULL DEFAULT (datetime('now')),
  FOREIGN KEY (from_user_id) REFERENCES users(id) ON DELETE SET NULL,
  FOREIGN KEY (to_user_id) REFERENCES users(id) ON DELETE SET NULL,
  FOREIGN KEY (related_gift_id) REFERENCES gifts(id) ON DELETE SET NULL
);

CREATE TABLE claims (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  gift_id INTEGER NOT NULL,
  claimer_user_id INTEGER NOT NULL,
  claimer_email TEXT,
  status TEXT NOT NULL DEFAULT 'claimed',
  created_at TEXT NOT NULL DEFAULT (datetime('now')),
  FOREIGN KEY (gift_id) REFERENCES gifts(id) ON DELETE CASCADE,
  FOREIGN KEY (claimer_user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE community_challenges (
  id INTEGER PRIMARY KEY,
  title TEXT,
  description TEXT,
  duration TEXT,
  challenge_type TEXT CHECK(challenge_type IN ('weekly','monthly','special')),
  status TEXT DEFAULT 'active',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE community_messages (
  id INTEGER PRIMARY KEY,
  sender_email TEXT,
  subject TEXT NOT NULL,
  body TEXT NOT NULL,
  audience TEXT DEFAULT 'all',
  sent_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE companions (
  id INTEGER PRIMARY KEY,
  user_email TEXT,
  companion_name TEXT,
  companion_type TEXT,
  bond_description TEXT,
  show_on_wall BOOLEAN DEFAULT 0,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE content_generations (
  id INTEGER PRIMARY KEY,
  user_email TEXT,
  content_type TEXT CHECK(content_type IN ('social_post','poem','transcript','activity_plan','image','idea_to_creation','inspiration','hashtags','bio','thank_you')),
  input_text TEXT,
  output_text TEXT,
  platform TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE donations (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER,
  email TEXT,
  amount INTEGER NOT NULL,
  angel_number TEXT,
  meaning TEXT,
  donation_type TEXT NOT NULL CHECK (donation_type IN ('tree','rice','general')),
  trees_planted INTEGER NOT NULL DEFAULT 0,
  black_rice_fields INTEGER NOT NULL DEFAULT 0,
  created_at TEXT NOT NULL DEFAULT (datetime('now')),
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
);

CREATE TABLE dreams (
  id INTEGER PRIMARY KEY,
  user_email TEXT,
  dream_description TEXT,
  dream_category TEXT CHECK(dream_category IN ('land','huis','opleiding','onderneming','overig')),
  ai_plan TEXT,
  status TEXT DEFAULT 'dreaming',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE eternal_lights (
  id INTEGER PRIMARY KEY,
  user_email TEXT NOT NULL,
  name_for TEXT NOT NULL,
  message TEXT,
  is_public BOOLEAN DEFAULT 0,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE event_rsvps (
  id INTEGER PRIMARY KEY,
  event_id INTEGER,
  user_email TEXT,
  user_name TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (event_id) REFERENCES events(id) ON DELETE CASCADE
);

CREATE TABLE events (
  id INTEGER PRIMARY KEY,
  organizer_email TEXT,
  title TEXT,
  description TEXT,
  event_type TEXT CHECK(event_type IN ('picknick','klusdag','wandeling','online_sessie','bijeenkomst','overig')),
  event_date DATETIME,
  location TEXT,
  max_attendees INTEGER,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE eye_wishes (
  id INTEGER PRIMARY KEY,
  user_email TEXT,
  raw_wish TEXT NOT NULL,
  ai_refined_wish TEXT,
  status TEXT DEFAULT 'open',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE founding_member_config (
  id INTEGER PRIMARY KEY CHECK (id = 1),
  total_slots INTEGER NOT NULL DEFAULT 100,
  slots_taken INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE fraud_party_counts (
  id INTEGER PRIMARY KEY,
  party_name TEXT UNIQUE,
  report_count INTEGER DEFAULT 0,
  threshold_reached BOOLEAN DEFAULT 0,
  admin_notified BOOLEAN DEFAULT 0,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE fraud_reports (
  id INTEGER PRIMARY KEY,
  reporter_email TEXT,
  reporter_name TEXT,
  is_anonymous BOOLEAN DEFAULT 1,
  target_party TEXT NOT NULL,
  description TEXT NOT NULL,
  evidence_description TEXT,
  status TEXT DEFAULT 'received' CHECK(status IN ('received','reviewed','grouped','legal_action')),
  admin_notes TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE friends_dashboard (
  id INTEGER PRIMARY KEY,
  user_email TEXT,
  total_invited INTEGER DEFAULT 0,
  active_referrals INTEGER DEFAULT 0,
  free_months_earned INTEGER DEFAULT 0,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE geluksmuntje_transactions (
  id INTEGER PRIMARY KEY,
  from_email TEXT,
  to_email TEXT,
  amount INTEGER NOT NULL DEFAULT 1,
  reason TEXT NOT NULL,
  personal_message TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE geluksmuntjes (
  id INTEGER PRIMARY KEY,
  user_email TEXT NOT NULL,
  balance INTEGER DEFAULT 0,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE gifts (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL,
  email TEXT,
  description TEXT NOT NULL,
  category TEXT NOT NULL CHECK (category IN ('ticket','item','verhaal','tijd','talent')),
  desired_return TEXT,
  status TEXT NOT NULL DEFAULT 'available' CHECK (status IN ('available','claimed','matched')),
  created_at TEXT NOT NULL DEFAULT (datetime('now')),
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE iris_huis_helpers (
  id INTEGER PRIMARY KEY,
  need_id INTEGER,
  helper_email TEXT NOT NULL,
  helper_name TEXT,
  message TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (need_id) REFERENCES iris_huis_needs(id) ON DELETE CASCADE
);

CREATE TABLE iris_huis_members (
  id INTEGER PRIMARY KEY,
  email TEXT NOT NULL,
  name TEXT,
  skills TEXT,
  availability TEXT,
  joined_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE iris_huis_needs (
  id INTEGER PRIMARY KEY,
  title TEXT NOT NULL,
  description TEXT,
  category TEXT CHECK(category IN ('verf','gereedschap','planten','meubels','hulp_schilderen','hulp_bouwen','hulp_tuinieren','hulp_organiseren','overig')),
  status TEXT DEFAULT 'open',
  fulfilled_by_email TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE iris_kring_meetings (
  id INTEGER PRIMARY KEY,
  title TEXT,
  meeting_date DATETIME,
  meeting_link TEXT,
  description TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE iris_kring_members (
  id INTEGER PRIMARY KEY,
  user_email TEXT,
  display_name TEXT,
  bio TEXT,
  joined_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE iris_kring_rsvps (
  id INTEGER PRIMARY KEY,
  meeting_id INTEGER,
  user_email TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (meeting_id) REFERENCES iris_kring_meetings(id) ON DELETE CASCADE
);

CREATE TABLE iris_zegels (
  id INTEGER PRIMARY KEY,
  user_email TEXT,
  total_zegels INTEGER DEFAULT 0,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE mirror_conversations (
  id INTEGER PRIMARY KEY,
  user_email TEXT,
  conversation_json TEXT,
  session_date DATE DEFAULT (date('now')),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE movement_diary (
  id INTEGER PRIMARY KEY,
  user_email TEXT,
  activity TEXT,
  body_feeling TEXT,
  food_notes TEXT,
  small_victory TEXT,
  entry_date DATE DEFAULT (date('now')),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE onboarding_emails (
  id INTEGER PRIMARY KEY,
  user_email TEXT,
  email_day INTEGER,
  sent BOOLEAN DEFAULT 0,
  sent_at DATETIME
);

CREATE TABLE pattern_analyses (
  id INTEGER PRIMARY KEY,
  user_email TEXT,
  analysis_period TEXT,
  recurring_words TEXT,
  recurring_themes TEXT,
  emotion_pattern TEXT,
  insight_text TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE pay_it_forward_flow (
  id INTEGER PRIMARY KEY,
  user_email TEXT,
  blessings_received INTEGER DEFAULT 0,
  blessings_given INTEGER DEFAULT 0,
  value_flowed_to_desert REAL DEFAULT 0,
  badge TEXT,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE payments (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL,
  amount INTEGER NOT NULL,
  currency TEXT NOT NULL DEFAULT 'eur',
  payment_type TEXT NOT NULL CHECK (payment_type IN ('single_session','monthly_subscription','founding_member_deposit','founding_member_subscription','donation','other')),
  stripe_session_id TEXT UNIQUE,
  status TEXT NOT NULL DEFAULT 'pending',
  created_at TEXT NOT NULL DEFAULT (datetime('now')),
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE people_helped_counter (
  id INTEGER PRIMARY KEY,
  total_count INTEGER DEFAULT 0,
  last_updated DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE referral_links (
  id INTEGER PRIMARY KEY,
  user_email TEXT,
  referral_code TEXT UNIQUE,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE referral_rewards (
  id INTEGER PRIMARY KEY,
  user_email TEXT,
  reward_type TEXT CHECK(reward_type IN ('free_month','wall_of_hope','ambassadeur_access','tree_on_name','lifetime_free')),
  reward_description TEXT,
  earned_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE referrals (
  id INTEGER PRIMARY KEY,
  referrer_email TEXT,
  referred_email TEXT,
  referral_code TEXT,
  referred_became_paying BOOLEAN DEFAULT 0,
  reward_given TEXT,
  reward_date DATETIME,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE remembrance_wall (
  id INTEGER PRIMARY KEY,
  user_email TEXT NOT NULL,
  display_name TEXT,
  memory_text TEXT NOT NULL,
  is_public BOOLEAN DEFAULT 0,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE resonance_entries (
  id INTEGER PRIMARY KEY,
  user_email TEXT,
  content_type TEXT CHECK(content_type IN ('video_link','image_description','text','audio_description','link')),
  content_text TEXT NOT NULL,
  ai_question TEXT,
  user_reflection TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE robijn_collection (
  id INTEGER PRIMARY KEY,
  user_email TEXT NOT NULL,
  robijnen_count INTEGER DEFAULT 0,
  title TEXT DEFAULT 'robijn in de ruwe',
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE robijn_transactions (
  id INTEGER PRIMARY KEY,
  user_email TEXT NOT NULL,
  amount INTEGER DEFAULT 1,
  reason TEXT NOT NULL,
  iris_message TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE ruilplatform_tiers (
  id INTEGER PRIMARY KEY,
  user_email TEXT,
  tier TEXT CHECK(tier IN ('gratis','premium','bedrijf')) DEFAULT 'gratis',
  matches_this_week INTEGER DEFAULT 0,
  matches_limit INTEGER DEFAULT 1,
  premium_since DATETIME,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE sessions (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL,
  email TEXT NOT NULL,
  q1 TEXT NOT NULL,
  q2 TEXT NOT NULL,
  q3 TEXT NOT NULL,
  q4 TEXT NOT NULL,
  q5 TEXT NOT NULL,
  reflection_text TEXT NOT NULL,
  payment_status TEXT NOT NULL DEFAULT 'pending',
  created_at TEXT NOT NULL DEFAULT (datetime('now')), q6_companion_answer TEXT, companion_reflection_text TEXT,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE sign_collection (
  id INTEGER PRIMARY KEY,
  user_email TEXT,
  object_description TEXT NOT NULL,
  where_found TEXT,
  what_thinking TEXT,
  personal_message TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE silent_witness_conversations (
  id INTEGER PRIMARY KEY,
  user_email TEXT,
  user_message TEXT NOT NULL,
  ai_response TEXT NOT NULL,
  session_id TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE social_share_templates (
  id INTEGER PRIMARY KEY,
  platform TEXT CHECK(platform IN ('facebook','instagram','whatsapp','email')),
  template_text TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE static_content (
  id INTEGER PRIMARY KEY,
  page_slug TEXT UNIQUE,
  title TEXT,
  body TEXT,
  display_order INTEGER,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE success_stories (
  id INTEGER PRIMARY KEY,
  user_email TEXT,
  display_name TEXT,
  story_text TEXT,
  approved BOOLEAN DEFAULT 0,
  featured BOOLEAN DEFAULT 0,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE tarot_archetypes (
  id INTEGER PRIMARY KEY,
  card_name TEXT NOT NULL,
  card_name_nl TEXT NOT NULL,
  light_meaning TEXT NOT NULL,
  shadow_meaning TEXT NOT NULL,
  hero_journey_phase TEXT CHECK(hero_journey_phase IN ('vertrek','beproeving','terugkeer')),
  image_description TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE translations (
  id INTEGER PRIMARY KEY,
  page_slug TEXT,
  language_code TEXT,
  title TEXT,
  body TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(page_slug, language_code)
);

CREATE TABLE two_year_motor_distributions (
  id INTEGER PRIMARY KEY,
  distribution_date DATETIME,
  amount_per_person INTEGER,
  recipients_count INTEGER,
  total_distributed INTEGER,
  admin_approved BOOLEAN DEFAULT 0,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE two_year_motor_participants (
  id INTEGER PRIMARY KEY,
  user_email TEXT,
  stripe_payment_id TEXT,
  deposit_amount INTEGER DEFAULT 20000,
  join_date DATETIME DEFAULT CURRENT_TIMESTAMP,
  eligible_date DATETIME,
  payout_status TEXT DEFAULT 'waiting' CHECK(payout_status IN ('waiting','eligible','paid','donated')),
  payout_amount INTEGER,
  payout_date DATETIME
);

CREATE TABLE two_year_motor_pool (
  id INTEGER PRIMARY KEY,
  total_pool INTEGER DEFAULT 0,
  total_participants INTEGER DEFAULT 0,
  total_paid_out INTEGER DEFAULT 0,
  last_distribution_date DATETIME,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE users (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  email TEXT NOT NULL UNIQUE,
  display_name TEXT,
  subscription_type TEXT NOT NULL DEFAULT 'none' CHECK (subscription_type IN ('none','single','monthly','founding_member')),
  is_founding_member INTEGER NOT NULL DEFAULT 0 CHECK (is_founding_member IN (0,1)),
  account_auth_status TEXT NOT NULL DEFAULT 'external_auth_required',
  created_at TEXT NOT NULL DEFAULT (datetime('now')),
  updated_at TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE voice_diary (
  id INTEGER PRIMARY KEY,
  user_email TEXT,
  transcript TEXT,
  ai_summary TEXT,
  detected_emotions TEXT,
  core_sentence TEXT,
  recurring_theme TEXT,
  entry_date DATE DEFAULT (date('now')),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE wall_of_hope (
  id INTEGER PRIMARY KEY,
  user_email TEXT,
  display_name TEXT,
  contribution_type TEXT CHECK(contribution_type IN ('donation','referral','founding_member','volunteer')),
  message TEXT,
  visible BOOLEAN DEFAULT 1,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE wishes (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL,
  email TEXT,
  item_description TEXT NOT NULL,
  how_to_get TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'available' CHECK (status IN ('available','claimed','gone')),
  created_at TEXT NOT NULL DEFAULT (datetime('now')),
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE zegel_transactions (
  id INTEGER PRIMARY KEY,
  user_email TEXT,
  amount INTEGER NOT NULL,
  reason TEXT NOT NULL,
  description TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE IF NOT EXISTS js_stat (
  oid bigint,
  slot_id bigint,
  aid bigint,
  uid int,
  country string,
  os int,
  gid_t5 int,
  act int,
  val int,
  paymode string,
  settle_val int,
  cost float,
  is_show int,
  uu string,
  ut string,
  ader_id int,
  app_name string,
  slot_id_s string,
  creative_id bigint)
partitioned by (`dt` string)
location 's3://logarchive.ym/au/js_stat';

MSCK REPAIR TABLE js_stat;

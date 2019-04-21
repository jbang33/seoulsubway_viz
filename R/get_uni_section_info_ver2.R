#get_uni_section_info_ver_2

load('../data/uni_section_info.RData') # 구버전 uni_section_info
load('../data/uni_station_degree.RData')
uni_section <- data.frame(section = unique(uni_section_info$section), stringsAsFactors = FALSE)

uni_section <- uni_section %>% separate(section, c('from','to'), remove=FALSE)

uni_section <- uni_section %>% rename(station = from ) %>%  
  left_join(uni_station_degree, by = 'station') %>% 
  rename(from = station, 
         from_lat = lat, from_long = long, from_address_gu = address_gu,
         station = to) %>% 
  left_join(uni_station_degree, by = 'station') %>% 
  rename(to = station, 
         to_lat = lat, to_long = long, to_address_gu = address_gu,)

uni_section <- uni_section %>% 
  mutate(address_gu = paste0(ifelse(from_address_gu != to_address_gu, 
                                    paste0(from_address_gu, '/', to_address_gu), 
                                    from_address_gu))) %>% 
  select(-from_address_gu, -to_address_gu)

uni_section$address_gu[str_detect(temp$address_gu, '-')] <- '종로구/서대문구'
uni_section %>% head
uni_section_info_ver_2 <- uni_section %>% as_tibble()

uni_section_info_ver_2 %>% head()

save(uni_section_info_ver_2, file = '../data/uni_section_info_ver_2.RData')



import i18n from "i18next";
import { initReactI18next } from "react-i18next";
import LanguageDetector from "i18next-browser-languagedetector";

import koCommon from "@/locales/ko/common.json";
import koNav from "@/locales/ko/nav.json";
import koProblem from "@/locales/ko/problem.json";
import koAuth from "@/locales/ko/auth.json";
import koProfile from "@/locales/ko/profile.json";
import koAdmin from "@/locales/ko/admin.json";
import koLanding from "@/locales/ko/landing.json";

import enCommon from "@/locales/en/common.json";
import enNav from "@/locales/en/nav.json";
import enProblem from "@/locales/en/problem.json";
import enAuth from "@/locales/en/auth.json";
import enProfile from "@/locales/en/profile.json";
import enAdmin from "@/locales/en/admin.json";
import enLanding from "@/locales/en/landing.json";

i18n
  .use(LanguageDetector)
  .use(initReactI18next)
  .init({
    resources: {
      ko: {
        common: koCommon,
        nav: koNav,
        problem: koProblem,
        auth: koAuth,
        profile: koProfile,
        admin: koAdmin,
        landing: koLanding,
      },
      en: {
        common: enCommon,
        nav: enNav,
        problem: enProblem,
        auth: enAuth,
        profile: enProfile,
        admin: enAdmin,
        landing: enLanding,
      },
    },
    fallbackLng: "en",
    defaultNS: "common",
    ns: ["common", "nav", "problem", "auth", "profile", "admin", "landing"],
    detection: {
      order: ["localStorage", "navigator"],
      lookupLocalStorage: "i18nextLng",
      caches: ["localStorage"],
    },
    interpolation: {
      escapeValue: false,
    },
  });

export default i18n;

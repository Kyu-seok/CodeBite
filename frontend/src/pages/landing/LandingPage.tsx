import { useEffect } from "react"
import { useTranslation } from 'react-i18next'
import { HeroSection } from "./HeroSection"
import { ScienceSection } from "./ScienceSection"
import { MethodSection } from "./MethodSection"
import { CtaSection } from "./CtaSection"
import { FooterSection } from "./FooterSection"

export default function LandingPage() {
  const { t } = useTranslation('landing')

  useEffect(() => {
    document.title = t('meta.title')
  }, [])

  return (
    <>
      <HeroSection />
      <ScienceSection />
      <MethodSection />
      <CtaSection />
      <FooterSection />
    </>
  )
}

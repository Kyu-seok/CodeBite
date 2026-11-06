import { useTranslation } from 'react-i18next'
import { useDocumentMeta } from "@/hooks/useDocumentMeta"
import { HeroSection } from "./HeroSection"
import { ScienceSection } from "./ScienceSection"
import { MethodSection } from "./MethodSection"
import { CtaSection } from "./CtaSection"
import { FooterSection } from "./FooterSection"

export default function LandingPage() {
  const { t } = useTranslation('landing')

  useDocumentMeta({ title: t('meta.title'), description: t('meta.description'), path: '/' })

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

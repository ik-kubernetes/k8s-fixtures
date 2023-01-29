# Flux VS Argo

## Shall we switch to flux

Closed

Shall we switch to flux

## [](moz-extension://154c5342-3177-f74e-b049-af53c502a9b1/_generated_background_page.html#problem)Problem

-   How can we be competitive with more mature GitOps solutions that exist on the market?
-   Ship value faster, continuously

### [](moz-extension://154c5342-3177-f74e-b049-af53c502a9b1/_generated_background_page.html#user-problems-we-want-to-solve)User problems we want to solve

1.  Allow our users to benefit from feature-rich, best-in-class GitOps solutions that includes (non-exhaustive list)
    -   full Helm support
    -   full Kustomize support
    -   support for non-GitLab manifest repositories
    -   support for push-based cluster to cluster synchronization
    -   avoiding orphaned resources left behind in the cluster
    -   notifications integrations with GitLab and/or other tools, like Slack
    -   enable a flexible and dynamic definition of a hierarchy of manifest sources
2.  Preferably keep the access control within GitLab
3.  Simplify adoption and onboarding workflows
4.  Make it easy for users to test their GitOps deployments, develop locally, and debug live production deployments
5.  Integrate with GitLab pipelines for pre- and post-deployment automation, deploy freezes, etc
6.  Provide a well-defined integration point for GitLab Environment integration supporting [#352186](https://gitlab.com/gitlab-org/gitlab/-/issues/352186 "Add Environments support to the GitLab Agent") ([MR](https://gitlab.com/gitlab-org/gitlab/-/issues/382729 "Write Blueprint for Integration of Environment/Deployment and Pull-based Deployment (e.g. GitOps mode in GitLab Agent for Kubernetes)"))
7.  Refocus our efforts around the experience _within GitLab_ their faster pace of development

## [](moz-extension://154c5342-3177-f74e-b049-af53c502a9b1/_generated_background_page.html#discussion-starter)Discussion starter

I would like us to (re)consider switching from `cli-utils` to `flux` for GitOps. I don't know if we use `cli-utils` for CI/CD too to apply the changes to the cluster. Let me know if we do.

I think about the agent as the layer that provides a connection between a cluster and GitLab, and we build higher-level functionalities on top of it. Such functionalities are the GitOps and CI/CD workflows, and the operational container scanning.

In the GitOps workflow, there are two, strong incumbent players, the Argo project and Flux.

### [](moz-extension://154c5342-3177-f74e-b049-af53c502a9b1/_generated_background_page.html#a-few-words-about-argo)A few words about Argo

-   The Argo project is an incubating project at the CNCF. (The CNCF has 3 levels of maturity, sandbox, incubating, graduated.)
-   The Argo project consists of
    -   ArgoCD
    -   Argo Event
    -   Argo Workflows
    -   Argo Rollouts
-   ArgoCD is an all-in GitOps solution including a really powerful UI. It has good integrations with the other Argo projects, especially Argo rollouts
-   ArgoCD can be deployed without a UI too, that's called Argo Core
-   ArgoCD is built on the `gitops-engine`
-   We decided to move away from the `gitops–engine` to `cli-utils` to decrease the number of dependencies and to follow a more modern architecture. I think this was a really good idea from Mikhail. We benefit from features that Argo does not offer like server-side applies. The Argo workarounds are pretty messy.
-   Argo was built and donated to the CNCF by Intuit. Akuity was created to commercialise it as Intuit did not have an interest in building a business around it.

### [](moz-extension://154c5342-3177-f74e-b049-af53c502a9b1/_generated_background_page.html#a-few-words-about-flux)A few words about Flux

-   The Flux project is an incubating project at the CNCF.
-   The Flux project is composed of [a set of components](https://fluxcd.io/docs/components/) that form the GitOps toolkit.
-   Weaveworks has other projects (Flagger) to support progressive delivery. The equivalent of Argo Rollouts.
-   Flux was built and donated to the CNCF by Weaveworks. Weave offers Weave Cloud as a business offering to customers.
-   I am speaking about Flux v2 here. When we started the work on the Agent, Flux v2 did not exist yet. At the time, it was not an option for us.
-   Thanks to its component-based approach, Flux is very flexible. For example, the community built a [Terraform controller](https://github.com/weaveworks/tf-controller) on top of Flux.

### [](moz-extension://154c5342-3177-f74e-b049-af53c502a9b1/_generated_background_page.html#what-would-be-the-role-of-the-agent)What would be the role of the agent

-   Setting up Flux when needed based on the agent configuration. The agent would act as an operator, picking the version of Flux that we want it to use.
-   Managing the GitLab Personal/Project access tokens for Flux to access GitLab source and container repositories
-   Provide a higher-level abstraction for [GitRepository](https://fluxcd.io/flux/components/source/gitrepositories/), [Kustomization](https://fluxcd.io/flux/components/kustomize/kustomization/), etc.

The agent would provide the bi-directional communication channel, so we can build a UI on top of it to show the deployment status and resource details. Later on, we might need to extend/rewrite Flux's SourceController to add support to [Support clusters that can't see GitLab (#350943)](https://gitlab.com/gitlab-org/gitlab/-/issues/350943 "Support clusters that can't see GitLab").

### [](moz-extension://154c5342-3177-f74e-b049-af53c502a9b1/_generated_background_page.html#what-would-we-gain-by-adopting-flux)What would we gain by adopting Flux

-   We would tap into a healthy CNCF community that is focused on improving the Flux components
-   Flux would bring a few extra features that we don't have to build ourselves. These would be mostly in the form of
    -   Notification controller
    -   Image automation controller
    -   Full Helm support
    -   Full Kustomize support
    -   Support for git/container/Helm registries outside of GitLab

### [](moz-extension://154c5342-3177-f74e-b049-af53c502a9b1/_generated_background_page.html#what-would-we-lose)What would we lose

\-- To be filled out --

### [](moz-extension://154c5342-3177-f74e-b049-af53c502a9b1/_generated_background_page.html#why-flux-and-not-argocd)Why Flux and not ArgoCD

My impression is that Flux has a more modern architecture than ArgoCD. Moreover, it already has a few [other integrations built on top](https://fluxcd.io/ecosystem/#integrations) of it.

At the same time, ArgoCD has its benefits too that I don't want to hide.

-   ArgoCD likely has wider adoption. Today, I expect ArgoCD to win the market of ready-to-use GitOps tools. We don't want to build a ready-to-use GitOps tool. We want to build an integrated experience between GitLab and Kubernetes clusters. GitOps is only a small part of it.
-   ArgoCD is application-focused, and this approach is much liked by many of its users. At the same time, this is one of its weaknesses. It does not lend itself well to COTS application deployments. Could we build a layer on top of Flux that adds a concept of applications to it? I think we can.
-   ArgoCD's biggest selling point is it's UI, and we would need to rebuild it within GitLab anyway.

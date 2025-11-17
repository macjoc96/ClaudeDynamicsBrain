---
description: Conduct a comprehensive security audit of Dynamics code, configurations, and integrations identifying vulnerabilities and recommending fixes
argument-hint: [CodePath]
allowed-tools: Read, Grep, Bash
model: sonnet
---

Conduct a comprehensive security audit with the following areas:

## Task
Perform a detailed security review including:
- OWASP Top 10 vulnerability scanning
- Input validation analysis
- Authentication and authorization checks
- Data protection assessment
- Error handling review
- Credential management audit
- API security review
- SQL injection risk assessment
- XSS vulnerability detection
- CORS and security headers validation
- Compliance checklist
- Risk rating and remediation priorities

## Target to Scan
- Code Path: $ARGUMENTS (file or directory)
- Scan Type: Full security review (default)
- Severity Level: All (configurable)

## Security Checks
1. Code vulnerability scanning
2. Configuration security validation
3. Credentials and secrets detection
4. Authentication method review
5. Permission and access control validation
6. Data protection mechanisms
7. Error handling safety
8. Logging and monitoring
9. Third-party dependency scan
10. Compliance requirements check

## Output
Provide:
1. Executive summary
2. Vulnerability list with severity ratings
3. Detailed findings and evidence
4. Remediation recommendations
5. Compliance assessment
6. Priority-ordered fix list
7. Security best practices guide
8. Test plan for verification

Delegation to security-reviewer agent recommended for detailed analysis.

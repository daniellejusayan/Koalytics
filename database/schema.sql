--CORE TABLES
--TODO: Users Table 
CREATE TABLE Users (
    id BIGINT Auto_INCREMENT PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    base_role ENUM('SURVEY TAKER', 'RESEARCHER') DEFAULT 'SURVEY TAKER',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
    rewards_balance INT DEFAULT 0
);

--TODO: Projects Table
CREATE TABLE Projects (
    id BIGINT Auto_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    status ENUM('DRAFT', 'PUBLISHED', 'CLOSED') DEFAULT 'DRAFT',
    consent_form TEXT,
    biometric_enabled BOOLEAN DEFAULT FALSE,
    max_participants INT,
    start_date DATETIME,
    end_date DATETIME,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
    --NOTE: no owner_id here anymore - handled in Project Roles
);

--TODO: Project Table
CREATE TABLE Project_Roles (
    id BIGINT Auto_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    project_id BIGINT UNIQUE NOT NULL,
    role_type ENUM('OWNER', 'COLLABORATOR') NOT NULL,
    collaborator_level ENUM('EDITOR', 'COMMENTER', 'VIEWER') NULL,
    permissions JSON, --Flexible permissions storage
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(id) ON DELETE CASCADE,
    FOREIGN KEY (project_id) REFERENCES Projects(id) ON DELETE CASCADE,
    UNIQUE KEY unique_user_project_role (user_id, project_id, role_type)
    -- Constraint: collaborator_level must be NULL for OWNER, required for COLLABORATOR

    CONSTRAINT chk_collaborator_level CHECK (
        (role_type = 'OWNER' AND collaborator_level IS NULL) OR
        (role_type = 'COLLABORATOR' AND collaborator_level IS NOT NULL)
    )
);

CREATE TABLE Collaborations (
    id BIGINT Auto_INCREMENT PRIMARY KEY,
    project_id BIGINT NOT NULL,
    invited_user_id BIGINT NOT NULL,
    invited_by_user_id BIGINT NOT NULL,
    role_type ENUM('COLLABORATOR') NOT NULL DEFAULT 'COLLABORATOR',
    collaborator_level ENUM('EDITOR', 'COMMENTER', 'VIEWER') NOT NULL,
    status ENUM('PENDING', 'ACCEPTED', 'DECLINED') DEFAULT 'PENDING',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (project_id) REFERENCE Projects(id) ON DELETE CASCADE,
    FOREIGN KEY (invited_user_id) REFERENCE Users(id) ON DELETE CASCADE,
    FOREIGN KEY (invited_by_user_id) REFERENCE USERS(id) ON DELETE CASCADE
);

-- Project Roles
-- Collaborations
-- Test Session
-- SUS Questionnaires
-- Facial Data
-- Responses
-- Test Results
-- Emotion Analysis
-- Task Metrics
-- Rewards

